% check files

perm_dir = 'D:\SEBs\Data\2nd_levels_permuted_noDep_real';

expected_perms = 1:1000;
expected_betas = 103;
expected_Fs = 72;

folder_names = '2nd_level_bins-72_shuffle1-0_shuffle2- _wANOVA'; % sprintf('%s/ses-2/func', sj)

for p = expected_perms

    folder_name = sprintf('2nd_level_bins-72_shuffle1-0_shuffle2-%s_wANOVA', num2str(p));

    try
        cd([perm_dir filesep folder_name]);
        pb = dir('beta_*.nii');
        if length(pb) ~= expected_betas
            warning(sprintf('Folder %s is missing betas!', folder_name))
            for b = 1:expected_betas
                if b < 10
                    beta_string = ['beta_000' num2str(b) '.nii'];
                elseif b < 100
                    beta_string = ['beta_00' num2str(b) '.nii'];
                else
                    beta_string = ['beta_0' num2str(b) '.nii'];
                end
                                
                try
                    info = niftiinfo(beta_string);
                catch
                    warning(sprintf('%s is missing!', beta_string));
                end
            end
        end
        pf = dir('spmF_*.nii');
        if length(pf) ~= expected_Fs
            warning(sprintf('Folder %s is missing F-maps!', folder_name))
        end
    catch
        warning(sprintf('Unable to change current folder to %s (Name is nonexistent or not a folder).', folder_name))
    end

end