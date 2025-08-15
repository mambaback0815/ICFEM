function solveByGetDP_leadfield_all(sigma,save_path,name,species,i)
% solveByGetDP(P,current,sigma,indUse,uniTag,LFtag)
% 
% Solve in getDP, a free FEM solver available at 
% http://getdp.info/
%
% (c) Yu (Andy) Huang, Parra Lab at CCNY
% yhuang16@citymail.cuny.edu
% October 2017
% August 2019 adding lead field


V=0;
current=[1,-1];
load([save_path  name '_usedElecArea.mat'],'area_elecNeeded');



fid = fopen([save_path name num2str(i) '.pro'],'w');

fprintf(fid,'%s\n\n','Group {');
switch species
    case 'mice'
        fprintf(fid,'%s\n','skin = Region[1];');
        fprintf(fid,'%s\n','skeleton = Region[2];');
        fprintf(fid,'%s\n','gray = Region[3];');
        fprintf(fid,'%s\n','white = Region[4];');
        fprintf(fid,'%s\n','csf = Region[5];');
        fprintf(fid,'%s\n','muscle = Region[6];');
    case 'rat'
        fprintf(fid,'%s\n','skin = Region[1];');
        fprintf(fid,'%s\n','muscle = Region[2];');
        fprintf(fid,'%s\n','skeleton = Region[3];');
        fprintf(fid,'%s\n','csf = Region[4];');
        fprintf(fid,'%s\n','gray = Region[5];');
        fprintf(fid,'%s\n','white = Region[6];');
    case 'monkey'
        fprintf(fid,'%s\n','gray = Region[1];');
        fprintf(fid,'%s\n','white = Region[2];');
        fprintf(fid,'%s\n','csf = Region[3];');
        fprintf(fid,'%s\n','skeleton = Region[4];');
        fprintf(fid,'%s\n','skin = Region[5];');
        fprintf(fid,'%s\n','muscle = Region[6];');
   case 'human'
        fprintf(fid,'%s\n','white = Region[1];');
        fprintf(fid,'%s\n','gray = Region[2];');
        fprintf(fid,'%s\n','csf = Region[3];');
        fprintf(fid,'%s\n','skeleton = Region[4];');
        fprintf(fid,'%s\n','skin = Region[5];');
        fprintf(fid,'%s\n','muscle = Region[6];');
    otherwise 
        error('No match species')
end
fprintf(fid,'%s\n','elec1 = Region[7];');
fprintf(fid,'%s\n','pad1 = Region[8];');
fprintf(fid,'%s\n','elec2 = Region[9];');
fprintf(fid,'%s\n','pad2 = Region[10];');

fprintf(fid,'%s\n','usedElec1 = Region[11];');
fprintf(fid,'%s\n','usedElec2 = Region[12];');


fprintf(fid,'%s\n',['DomainC = Region[{skin, skeleton, gray, white, csf, muscle, elec1, pad1, elec2, pad2}];']);
fprintf(fid,'%s\n\n',['AllDomain = Region[{skin, skeleton, gray, white, csf, muscle, elec1, pad1, elec2, pad2, usedElec1, usedElec2}];']);
fprintf(fid,'%s\n\n','}');
fprintf(fid,'%s\n\n','Function {');
fprintf(fid,'%s\n',['sigma[skin] = ' num2str(sigma.skin) ';']);
fprintf(fid,'%s\n',['sigma[skeleton] = ' num2str(sigma.skeleton) ';']);
fprintf(fid,'%s\n',['sigma[gray] = ' num2str(sigma.gray) ';']);
fprintf(fid,'%s\n',['sigma[white] = ' num2str(sigma.white) ';']);
fprintf(fid,'%s\n',['sigma[csf] = ' num2str(sigma.csf) ';']);
switch species
    case 'human'
        fprintf(fid,'%s\n',['sigma[muscle] = ' num2str(sigma.air) ';']);
    otherwise
        fprintf(fid,'%s\n',['sigma[muscle] = ' num2str(sigma.muscle) ';']);
end
fprintf(fid,'%s\n',['sigma[elec1] = ' num2str(sigma.electrode) ';']);
fprintf(fid,'%s\n',['sigma[pad1] = ' num2str(sigma.pad) ';']);
fprintf(fid,'%s\n',['sigma[elec2] = ' num2str(sigma.electrode) ';']);
fprintf(fid,'%s\n',['sigma[pad2] = ' num2str(sigma.pad) ';']);


for n=1:2
    fprintf(fid,'%s\n',['du_dn' num2str(n) '[] = ' num2str(1000*current(n)/area_elecNeeded(n)) ';']);
end

fprintf(fid,'%s\n\n','}');

% fprintf(fid,'%s\n\n','Constraint {');
% fprintf(fid,'%s\n','{ Name ElectricScalarPotential; Type Assign;');
% fprintf(fid,'%s\n','  Case {');
% fprintf(fid,'%s\n','    { Region cathode; Value 0; }');
% fprintf(fid,'%s\n','  }');
% fprintf(fid,'%s\n\n','}');
% fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','Jacobian {');
fprintf(fid,'%s\n','  { Name Vol ;');
fprintf(fid,'%s\n','    Case {');
fprintf(fid,'%s\n','      { Region All ; Jacobian Vol ; }');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n','  { Name Sur ;');
fprintf(fid,'%s\n','    Case {');
fprintf(fid,'%s\n','      { Region All ; Jacobian Sur ; }');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','Integration {');
fprintf(fid,'%s\n','  { Name GradGrad ;');
fprintf(fid,'%s\n','    Case { {Type Gauss ;');
fprintf(fid,'%s\n','            Case { { GeoElement Triangle    ; NumberOfPoints  3 ; }');
fprintf(fid,'%s\n','                   { GeoElement Quadrangle  ; NumberOfPoints  4 ; }');
fprintf(fid,'%s\n','                   { GeoElement Tetrahedron ; NumberOfPoints  4 ; }');
fprintf(fid,'%s\n','                   { GeoElement Hexahedron  ; NumberOfPoints  6 ; }');
fprintf(fid,'%s\n','                   { GeoElement Prism       ; NumberOfPoints  9 ; } }');
fprintf(fid,'%s\n','           }');
fprintf(fid,'%s\n','         }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','FunctionSpace {');
fprintf(fid,'%s\n','  { Name Hgrad_v_Ele; Type Form0;');
fprintf(fid,'%s\n','    BasisFunction {');
fprintf(fid,'%s\n','      // v = v  s   ,  for all nodes');
fprintf(fid,'%s\n','      //      n  n');
fprintf(fid,'%s\n','      { Name sn; NameOfCoef vn; Function BF_Node;');
fprintf(fid,'%s\n','        Support AllDomain; Entity NodesOf[ All ]; }');
fprintf(fid,'%s\n','    }');
% fprintf(fid,'%s\n','    Constraint {');
% fprintf(fid,'%s\n','      { NameOfCoef vn; EntityType NodesOf; ');
% fprintf(fid,'%s\n','        NameOfConstraint ElectricScalarPotential; }');
% fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','Formulation {');
fprintf(fid,'%s\n','  { Name Electrostatics_v; Type FemEquation;');
fprintf(fid,'%s\n','    Quantity {');
fprintf(fid,'%s\n','      { Name v; Type Local; NameOfSpace Hgrad_v_Ele; }');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','    Equation {');
fprintf(fid,'%s\n','      Galerkin { [ sigma[] * Dof{d v} , {d v} ]; In DomainC; ');
fprintf(fid,'%s\n\n','                 Jacobian Vol; Integration GradGrad; }');

for n=1:2
    
    fprintf(fid,'%s\n',['      Galerkin{ [ -du_dn' num2str(n) '[], {v} ]; In usedElec' num2str(n) ';']);
    fprintf(fid,'%s\n','                 Jacobian Sur; Integration GradGrad;}');
    
end

fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','Resolution {');
fprintf(fid,'%s\n','  { Name EleSta_v;');
fprintf(fid,'%s\n','    System {');
fprintf(fid,'%s\n','      { Name Sys_Ele; NameOfFormulation Electrostatics_v; }');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','    Operation { ');
fprintf(fid,'%s\n','      Generate[Sys_Ele]; Solve[Sys_Ele]; SaveSolution[Sys_Ele];');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n\n','}');

fprintf(fid,'%s\n','PostProcessing {');
fprintf(fid,'%s\n','  { Name EleSta_v; NameOfFormulation Electrostatics_v;');
fprintf(fid,'%s\n','    Quantity {');
fprintf(fid,'%s\n','      { Name v; ');
fprintf(fid,'%s\n','        Value { ');
fprintf(fid,'%s\n','          Local { [ {v} ]; In AllDomain; Jacobian Vol; } ');
fprintf(fid,'%s\n','        }');
fprintf(fid,'%s\n','      }');
fprintf(fid,'%s\n','      { Name e; ');
fprintf(fid,'%s\n','        Value { ');
fprintf(fid,'%s\n','          Local { [ -{d v} ]; In AllDomain; Jacobian Vol; }');
fprintf(fid,'%s\n','        }');
fprintf(fid,'%s\n','      }');
fprintf(fid,'%s\n','    }');
fprintf(fid,'%s\n','  }');
fprintf(fid,'%s\n','}');

fprintf(fid,'%s\n\n','PostOperation {');
fprintf(fid,'%s\n','{ Name Map; NameOfPostProcessing EleSta_v;');
fprintf(fid,'%s\n','   Operation {');
if isempty(V)
    fprintf(fid,'%s\n',['     Print [ v, OnElementsOf DomainC, File "'   name '_v' num2str(i) '.pos", Format NodeTable ];']);
end
fprintf(fid,'%s\n',['     Print [ e, OnElementsOf DomainC, Smoothing, File "'   name '_e' num2str(i) '.pos", Format NodeTable ];']);
fprintf(fid,'%s\n','   }');
fprintf(fid,'%s\n\n','}');
fprintf(fid,'%s\n','}');

fclose(fid);

path = mfilename('fullpath');
[dirname_getdp,~] = fileparts(path);
disp(dirname_getdp);

str = computer('arch');
switch str
    case 'win64'
        solverPath = [dirname_getdp filesep 'lib\getdp-3.2.0\bin\getdp.exe'];
    case 'glnxa64'
        solverPath = [dirname_getdp filesep 'lib/getdp-3.2.0/bin/getdp'];
    case 'maci64'
        solverPath = 'lib/getdp-3.2.0/bin/getdpMac';
    otherwise
        error('Unsupported operating system!');
end

% cmd = [fileparts(which(mfilename)) filesep solverPath ' '...
%     fileparts(which(mfilename)) filesep dirname filesep baseFilename '_' uniTag '.pro -solve EleSta_v -msh '...
%     fileparts(which(mfilename)) filesep dirname filesep baseFilename '_' uniTag '_ready.msh -pos Map'];
cmd = [solverPath ' "' save_path name num2str(i) '.pro" -solve EleSta_v -msh "' save_path name '_elec' num2str(i) '_ready.msh" -pos Map'];
try
    status = system(cmd);
catch
end

if status
    error('getDP solver cannot work properly on your system. Please check any error message you got.');
else % after solving, delete intermediate files
    delete([save_path  name num2str(i) '.pre']);
    delete([save_path name num2str(i) '.res']);
end