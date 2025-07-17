% resort into sessions becuase why not

src_dir = 'D:\IMACU\Data';

cd(src_dir)
clear SJs
pb=dir('sub*');
for i=1:length(pb)
    SJs(1,i)={pb(i).name};
end

display('Subjects found:')
SJs % analysis for these subjects
display('Subjects to exclude:')
excludeSJ = [] % exclude those sjs: 1 22 | 9 16 25 30 | 8 10 23 | 4 17 18 24
excludeRuns = [];

prefixes = {''};
wanted_sessions = {'ses-1', 'ses-2'};
ses_runs = [1:7; 8:14];
renamer = [4 5 6 7 1 2 3];

sessNum = 0;
jsons = 1;

% if exist([src_dir filesep SJs{2} filesep 'ses-1'])==7 %################################### skript can't (yet) process multiple sessions per subject #################################
%     cd([src_dir filesep SJs{2}])
%     sd = dir('ses*');
%     sessNum = length(sd);
%     for sess = sessNum
%         sessions(1, sess) = {sd(sess).name};
%     end
%     for sb = 2:numel(SJs)
%         cd([src_dir filesep SJs{sb} filesep sessions{1} filesep 'func']);
%         rd = dir('sub*.json');
%         counter = 0;
%         for r = 1:length(rd)
%             if ismember(r, excludeRuns)
%                 continue;
%             else
%                 counter = counter +1;
%                 this_name = rd(r).name;
%                 if jsons
%                     this_name(regexp(this_name, '.json'):end) = [];
%                     this_name = [this_name '.nii'];
%                 end
%                 runs(sb, counter) = {this_name};
%                 % runs(sb, r) = {rd(r).name};
%             end
%         end
%     end
% else
    for sb = 2:numel(SJs)
        cd([src_dir filesep SJs{sb} filesep 'func']);
        rd = dir('sub*.json');
        counter = 0;
        for r = 1:length(rd)
            if ismember(r, excludeRuns)
                continue;
            else
                counter = counter +1;
                this_name = rd(r).name;
                if jsons
                    this_name(regexp(this_name, '.json'):end) = [];
                    this_name = [this_name '.nii'];
                end
                runs(sb, counter) = {this_name};
            end
        end
    end
% end


%% resort

for s = 1:numel(SJs)
    s

    sj_dir = [src_dir filesep SJs{s}];
    func_dir = [src_dir filesep SJs{s} filesep 'func'];

    for ses = 1:numel(wanted_sessions)
        ses
       
        ses_dir = [sj_dir filesep wanted_sessions{ses}];
        if ~exist(ses_dir, 'dir')
            mkdir(ses_dir)
        end
        func_ses = [ses_dir filesep 'func'];
        if ~exist(func_ses, 'dir')
            mkdir(func_ses)
        end

        % movefile(source,destination)
        copyfile([sj_dir filesep 'anat'],[ses_dir filesep 'anat']);
    	counter = 0;
        for r = ses_runs(ses, :)
            r
    	    counter = counter + 1;
            for p = 1:numel(prefixes)
                pref = prefixes{p};
                new_name = runs{s,r};
                new_name((regexp(new_name, 'run-')+4):end) = [];
                new_name = [new_name num2str(renamer(counter)) '_bold.nii'];
                movefile([func_dir filesep pref runs{s,r}],[func_ses filesep pref new_name]);
        		if p == 1
        		    this_name = runs{s,r};
                    this_name(regexp(this_name, '.nii'):end) = [];
                    this_name = [this_name '.json'];

                    new_name = this_name;
                    new_name((regexp(new_name, 'run-')+4):end) = [];
                    new_name = [new_name num2str(renamer(counter)) '_bold.json'];

        		    movefile([func_dir filesep this_name],[func_ses filesep new_name]);
        		end
            end
        end
    end
end