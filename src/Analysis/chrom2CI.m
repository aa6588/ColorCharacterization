function CI = chrom2CI(chrom_obs,chrom_test,chrom_ref)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

trial_num = length(chrom_obs);

b = ...
    sqrt((repmat(chrom_test(1),trial_num,1) - chrom_obs(:,1)).^2 + ...
    (repmat(chrom_test(2),trial_num,1) - chrom_obs(:,2)).^2);
a = ...
    sqrt((repmat(chrom_test(1),trial_num,1) - repmat(chrom_ref(1),trial_num,1)).^2 + ...
    (repmat(chrom_test(2),trial_num,1) - repmat(chrom_ref(2),trial_num,1)).^2);

CI = 1 - (b./a);
end