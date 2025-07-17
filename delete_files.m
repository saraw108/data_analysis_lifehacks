% delete files to make space: local

src_dir = 'D:\SEB_BLOCK\Data';

del_folders = {'func'};
del_prefixes = {'rsub*.nii', 'rp_*.txt'};


for d = 1:length(del_folders)
    for pref = 1:length(del_prefixes)
        cd(src_dir)
        pb=dir(['**' filesep del_folders{1,d} filesep del_prefixes{pref}]);
        for i=1:length(pb)
            if exist([pb(i).folder]) == 7 && isempty(dir([pb(i).folder filesep del_prefixes{pref}]))
                remove(pb(i).folder)
                disp(['Deleting folder ' pb(i).folder])
            else
                delete([pb(i).folder filesep pb(i).name]);
                disp(['Deleting ' pb(i).name ' in folder ' pb(i).folder])
            end

        end
    end
end