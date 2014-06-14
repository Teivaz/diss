function [exists] = exists_data(name)
	all_dirs = [];
    cd('cache');
	all_files = ls();

	for file = all_files'
		if isdir(file)
			all_dirs = [all_dirs; file'];
		end
	end

	exists = 0;
	for dir = all_dirs'		
		if strcmpi(strtrim(dir'), name)
			exists = 1;
			break;
		end
    end
    cd('..');
end