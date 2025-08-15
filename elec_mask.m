function [maskelec1, maskelec2] = elec_mask(tissuemask , position, depth, direction, electype)
tissue  = load_untouch_nii(tissuemask);




switch electype
    case 1  %'nail'
        r1=3;
        h1=2;
        r2=r1;
        h2=30;
    case 2  %'needle'
        r1=2;
        h1=2;
        r2=r1;
        h2=30;
    case 3  %'disc'
        r1=15;
        h1=2;
        r2=r1;
        h2=3;
    otherwise 
        error('No match electype')
end



%elec1
direction = direction / norm(direction);
position1=position+direction*depth-direction*h1/2;

maskelec1=elecmask(tissue,position1,r1,h1,direction,7);




%pad1
position2=position1-direction*(h1+h2)/2;

maskelec2=elecmask(tissue,position2,r2,h2,direction,8);




