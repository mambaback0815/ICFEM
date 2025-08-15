function [x, cvx_status]=intensity_tacs(lfm, lfm_target)




module_lfm= sqrt(sum(lfm_target.^2, 2));
module_lfm = squeeze(module_lfm);  
n=size(lfm,3);
cvx_begin
    variable x(n)
    maximize(sum(module_lfm * x));
    subject to 
        
        norm(x, 1) <= 1;
        sum(x) == 0;
     
cvx_end





end
