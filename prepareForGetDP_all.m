function [meshtag,readytag]=prepareForGetDP_all(save_path,uniTag,i,tissuemask, species)
meshtag = [save_path  uniTag '_elec'  num2str(i) '.msh'];
readytag =  [save_path '_' uniTag '_elec'  num2str(i)  '_ready.msh'];



if ~exist(meshtag)
        tissue=load_untouch_nii(tissuemask);
        elecNeeded=[1,1];
        load([save_path uniTag '_mesh.mat'],'node','elem');
        node=node(:,1:3);
        
        centers =  round ((node(elem(:,1),:)+ node(elem(:,2),:)+ node(elem(:,3),:)+ node(elem(:,4),:))/4);
        
       
        elem_reset = ~ismember(elem(:,5), [1:8, 8+2*i, 7+2*i]);
        
        
        linear_indices = sub2ind(size(tissue.img), centers(elem_reset, 1), centers(elem_reset, 2), centers(elem_reset, 3));
        real_tissue=tissue.img(linear_indices);
        real_tissue(real_tissue==0) =1;
        
        elem( elem_reset ,5) =  real_tissue;
        
        elem( elem(:,5)== 7+2*i ,5) =  9;
        elem( elem(:,5)== 8+2*i ,5) =  10;
        
        
        
        
        
        
        
        
        disp(['saving mesh for elec' num2str(i) ]);
        maskName = cell(1,10);
        
        switch species
        case 'mice'
            maskName(1:6) ={'SKIN','SKELETON','GRAY','WHITE','CSF','MUSCLE'};
        case 'rat'
            maskName(1:6) ={'SKIN','MUSCLE','SKELETON','CSF','GRAY','WHITE'};
        case 'monkey'
            maskName(1:6) ={'SKIN','SKELETON','GRAY','WHITE','CSF','MUSCLE'};
        case 'human'
            maskName(1:6) ={'SKIN','SKELETON','GRAY','WHITE','CSF','MUSCLE'};
        otherwise 
            error('No match species')
        end
        maskName{7} = 'REFELEC1' ;
        maskName{8} = 'REFPAD1';
        maskName{9} = ['ELEC' num2str(i)];
        maskName{10} = ['PAD' num2str(i)]; 
        
        if ~exist(meshtag)
        savemsh(node,elem,meshtag,maskName);
        end
        
        
        
        element_elecNeeded = cell(2,1);
        area_elecNeeded = zeros(2,1);
        
        
        
        
        
        
        
        
        for n=1:2
            
        %indNode_gelElm = elem(find(elem(:,5) ~= numOfTissue+i),1:4);    %分别找出elec和gel对应的elem对应的点'
        if n==1
        indNode_gelElm = elem(find(elem(:,5) == 8),1:4);
        indNode_elecElm = elem(find(elem(:,5) == 7),1:4);
        end
        
        if n==2
        indNode_gelElm = elem(find(elem(:,5) == 10),1:4);
        indNode_elecElm = elem(find(elem(:,5) == 9),1:4);
        end
        
        
        if isempty(indNode_gelElm)   %说明没有四面体被划分为对应的gel或者elem
            error(['Gel under electrode ' elecNeeded{n} ' was not meshed properly. Reasons may be: 1) electrode size is too small so the mesher cannot capture it; 2) mesh resolution is not high enough. Consider using bigger electrodes or increasing the mesh resolution by specifying the mesh options.']);
        end
        
        if isempty(indNode_elecElm)
            error(['Electrode ' elecNeeded{n} ' was not meshed properly. Reasons may be: 1) electrode size is too small so the mesher cannot capture it; 2) mesh resolution is not high enough. Consider using bigger electrodes or increasing the mesh resolution by specifying the mesh options.']);
        end   
        
        [~,verts_gel] = freeBoundary(TriRep(indNode_gelElm,node(:,1:3)));
        %trirep：第一个参数是需要链接的三角形的索引，第二个参数是点的坐标。那么trirep表示在三维空间中链接一些点
        %freeboundry用来提取四面体网格的外表面，第一个返回值是矩阵表示边界上的三角形面片的顶点索引，第二个返回顶点坐标
        [faces_elec,verts_elec] = freeBoundary(TriRep(indNode_elecElm,node(:,1:3)));
        %verts_gel,elec应当为电极和凝胶网格边界上的node坐标
        
        [~,iE,~] = intersect(verts_elec,verts_gel,'rows');
        %查询elec中的那些node在gel中出现（ie）
        tempTag = ismember(faces_elec,iE);%边界上的node索引与ie（elecnode和gelnode重叠的部分）返回边界上的node索引是否为重叠node
        % faces_overlap san= faces_elec(sum(tempTag,2)==3,:);
        
        
        faces_elecOuter = faces_elec(sum(tempTag,2)==3,:); 
        
        % faces_elecOuter = faces_elec(~(sum(tempTag,2)==3),:);%选出电极边界的三角形中非全部是共用三角形的
        [~,Loc] = ismember(verts_elec,node(:,1:3),'rows');%返回电极边界上的点在node里面的索引
        element_elecNeeded{n} = Loc(faces_elecOuter);%element——每个电极是电极边界中的非共同node
        % calculate the surface area
        a = (verts_elec(faces_elecOuter(:, 2),:) - verts_elec(faces_elecOuter(:, 1),:)); %*resolution;三角形一边向量 elec网格边界的边
        b = (verts_elec(faces_elecOuter(:, 3),:) - verts_elec(faces_elecOuter(:, 1),:)); %*resolution;三角形第二边向量
        c = cross(a, b, 2);%向量叉积 垂直于ab面1
        area_elecNeeded(n) = sum(0.5*sqrt(sum(c.^2, 2)));  %返回边界上三角形面积的总和
        
        end
        
        save([save_path  uniTag '_usedElecArea.mat'],'area_elecNeeded');  %用于solve中设定边界电流大小。1000mA/这个area
       
end

readytag =  [save_path uniTag '_elec'  num2str(i)  '_ready.msh'];
if ~exist(readytag,'file')
    
    disp('setting up boundary conditions...');
    
    fid_in = fopen(meshtag);
    fid_out = fopen(readytag,'w');
    
    numOfPart = length(unique(elem(:,5)));
    while ~feof(fid_in)
        s = fgetl(fid_in);
        
        if strcmp(s,'$Elements')
            fprintf(fid_out,'%s\n',s);
            s = fgetl(fid_in);
            numOfElem = str2num(s);
            fprintf(fid_out,'%s\n',num2str(numOfElem+size(cell2mat(element_elecNeeded),1)));
        elseif strcmp(s,'$EndElements')
            ii = 0;
            for j=1:2
                for n=1:size(element_elecNeeded{j},1)
                    
                    fprintf(fid_out,'%s \n',[num2str(numOfElem+n+ii) ' 2 2 ' num2str(numOfPart+j) ' ' num2str(numOfPart+j) ' ' num2str(element_elecNeeded{j}(n,1)) ' ' num2str(element_elecNeeded{j}(n,2)) ' ' num2str(element_elecNeeded{j}(n,3))]);
                    
                end
                ii = ii + n;
            end
            
            fprintf(fid_out,'%s\n',s);
        else
            fprintf(fid_out,'%s\n',s);
        end
    end
    
    fclose(fid_in);
    fclose(fid_out);
    
end