function tbl = replace_in_table(tbl, find_this, replace_with_this, columns)
% REPLACE_IN_TABLE Does a thing
%   tbl = REPLACE_IN_TABLE(tbl, find, replace) this is a use-case

    %% Find the size of the table
    [number_of_rows, number_of_columns] = size(tbl);

    %% Figure out which columns should be searched
    % If columns variable isn't initialized, then search all
    if ~exist('columns', 'var')
        columns = 1:number_of_columns;
    end

    % If columns variable is a list of names, find the column indices
    if iscell(columns)
        idx = zeros(1, length(columns));
        for i=1:1:length(columns)
            idx(i) = find(strcmp(tbl.Properties.VariableNames, columns{i}));
        end
        columns = idx;
    end
        
    %% Search and replace in the correct columns
    for i=1:1:length(columns)
        % Extract the column from the table
        data = tbl{:, columns(i)};
        
        % If searching cell data and replacing cell data, do that
        if iscell(find_this) && iscell(replace_with_this)
            if iscell(data)
                for j=1:1:length(find_this)
                    idx = find(strcmp(data, find_this{j}));
                    for k=1:1:length(idx)
                        data{idx(k)} = replace_with_this{j};
                    end
                end
                tbl.(columns(i)) = data;
            end
            
        % If searching for matrix data and replacing matrix data, do that
        elseif ~iscell(find_this) && ~iscell(replace_with_this)
            if ~iscell(data)
                for j=1:1:length(find_this);
                    idx = find(data == find_this(j));
                    for k=1:1:length(idx)
                        data(idx(k)) = replace_with_this(j);
                    end
                end
                tbl.(columns(i)) = data;
            end
            
        elseif ~iscell(find_this) && iscell(replace_with_this)
            if ~iscell(data)
            end
            
        % If searching for cell data and replacing with matrix data, do that
        elseif iscell(find_this) && ~iscell(replace_with_this)
            if iscell(data)
                newdata = nan(number_of_rows, 1);
                for j=1:1:length(find_this);
                    idx = find(strcmp(data, find_this{j}));
                    for k=1:1:length(idx)
                        newdata(idx(k)) = replace_with_this(j);
                    end
                end
                if ~all(isnan(newdata))
                    tbl.(columns(i)) = newdata;
                end
            end
        end            
    end
end