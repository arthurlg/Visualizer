function [ Data ] = Load_Formated_csv( File_Path, Separator)
%
BigNumber = 50000000;
Data = [];
%%
fid = fopen(File_Path);

Header = fgetl(fid);
Headers = textscan(Header,'%s','Delimiter',Separator);
Headers = Headers{1};

format = [];
for N= 1:length(Headers)
    if regexp (Headers{N},'date','ignorecase')
        format = [format,' %f-%f-%f %f:%f:%f',Separator];
        DateComumn = N
    else
        format = [format,' %f',Separator];
    end
end
format = format(1:end-1);

Data = [];
tic
fprintf('loading...')
for N = 1
% while ~feof(fid)
    variable = fgetl(fid);
    variable2 = strrep(variable, ',', '.');
    variable2 = strrep(variable2, ';;', [';',num2str(BigNumber),';']);
    variable2 = strrep(variable2, ';;', ';');
    Data = [Data;textscan(variable2, format)];
end
fprintf('done\n')
toc
fclose(fid);
%%
fprintf('converting...')
while ~feof(fid)
    variable = fgetl(fid);
    NewData  = [sscanf(variable,[' %f-%f-%f %f:%f:%f,%f',Separator,' %f,%f ',...
        Separator,'%f,%f',Separator,'%f,%f',Separator,'%f,%f',...
        Separator,'%f,%f',Separator,'%f,%f',Separator,'%f,%f',...
        Separator,'%f,%f',Separator,'%f,%f'])];
    Data = [Data ; NewData(1:3)';NewData(4:6)']; %#ok<AGROW>
end
fprintf('done\n')
Data = Data(1:Expected_Length,:);

end