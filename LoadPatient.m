
function dataWholeRecord = LoadPatient(filename, create_dat)

%             To select file with regards to specific patterns            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     addpath('H:\Etudes\Inria\Lariboisiere');
    %addpath('/Volumes/Data/arthur/Simulations/Datas/7_patient7');
    
    fprintf('loading\n')
    
    filename = filename(1:end-4);

    if (create_dat)
        commandStr = ['/Users/alexandrel/Documents/Projects/Arthur/script.py ' filename];
        [status, commandOut] = system(commandStr);
        if status~=0
            fprintf('Echec du script python !\n');
            return;
        else
            fprintf('Script successfuly created the file :)')
        end
    end
    
    f = fopen([filename '.csv'],'rt');
    if (f == -1)
        error(['Error in opening file ' filename]);
        data = 0;
        return;
    end   
    
    
    
    dataWholeRecord.Time = [];
    dataWholeRecord.DateTime = [];
    dataWholeRecord.ECG_III = [];
    dataWholeRecord.ECG_II = [];
    dataWholeRecord.ECG_I = [];
    dataWholeRecord.CompoundII = [];
    dataWholeRecord.CompoundV = [];
    dataWholeRecord.CompoundaVR = [];
    dataWholeRecord.CO2 = [];
    dataWholeRecord.Pleth = [];
    dataWholeRecord.EEG = [];
    dataWholeRecord.AWP = [];
    dataWholeRecord.ICP = [];
    dataWholeRecord.CVP = [];
    dataWholeRecord.FeO2 = [];
    dataWholeRecord.AWF = [];
    dataWholeRecord.CrbVol = [];
    dataWholeRecord.UAP = [];
    dataWholeRecord.Elapsed = [];
    dataWholeRecord.ECG_V_sel = [];
    dataWholeRecord.MCL = [];
    dataWholeRecord.AWRes = [];
    dataWholeRecord.Vel1 =[];
    dataWholeRecord.Vel2 =[];
    dataWholeRecord.PAP =[];
    dataWholeRecord.PA1 =[];
    dataWholeRecord.PA2 =[];
    dataWholeRecord.PA3 =[];
    
    Vel1Col =[];
    Vel2Col =[];
    PAPCol =[];
    PA1Col =[];
    PA2Col =[];
    PA3Col =[];
    ECG_IIICol = [];
    ECG_IICol = [];
    ECG_ICol = [];
    CO2Col =[];
    PlethCol = [];
    EEGCol = [];
    AWPCol = [];
    ICPCol = [];
    CompoundIICol = [];
    CompoundaVRCol = [];
    CompoundVCol = [];
    CVPCol = [];
    FeO2Col =[];
    AWFCol =[];
    CrbVolCol = [];
    UAPCol = [];
    ElapsedCol = [];
    ECG_VCol = [];
    MCLCol = [];
    AWResCol = [];
    DateTimeCol = [];
    
    CONST.Vel1_keyword = 'Wave 1-Vel(NOS)'; 
    CONST.Vel2_keyword = 'Wave 2-Vel(NOS)';
    CONST.PAP_keyword = 'PAP-PULM(mmHg)';
    CONST.PA1_keyword = 'Ao-AORT(mmHg)';
    CONST.PA2_keyword = 'ART-ART(mmHg)';
    CONST.PA3_keyword = 'ABP-ABP(mmHg)';
    CONST.CO2_keyword = 'CO2-CO2(mmHg)';
    CONST.Pleth_keyword = 'Pleth-PLETH(-)';
    CONST.DateTime_keyword = 'Date Time';
    CONST.EEG_keyword = 'EEG-CRTX(?V)';
    CONST.AWP_keyword = 'AWP-AWAY(cmH2O)';
    CONST.ICP_keyword = 'ICP-CRAN(mmHg)';
    CONST.CVP_keyword = 'CVP-CENT(mmHg)';
    CONST.FeO2_keyword = 'O2-O2(%)';
    CONST.AWF_keyword = 'AWF-AWAY(l/min)';
    CONST.CrbVol_keyword = 'CrbVol-CrbVol(ml)';
    CONST.UAP_keyword = 'UAP-UMB(mmHg)';
    CONST.Elapsed_keyword = 'Milliseconds since 01.01.1970';
    CONST.AWRes_keyword = 'Resp-RESP(Ohm)';
    CONST.ECG_V_keyword = 'V-V(mV)';
    CONST.MCL_keyword = 'MCL-MCL(mV)';
    CONST.ECGII_compound_keyword = 'Compound ECG-II(mV)';
    CONST.ECGaVR_compound_keyword = 'Compound ECG-aVR(mV)';
    CONST.ECGV_compound_keyword = 'Compound ECG-V(mV)';
    CONST.ECG_I_keyword = 'I-I(mV)';
    CONST.ECG_III_keyword = 'III-III(mV)' ;
    CONST.ECG_II_keyword = 'II-II(mV)';

    header = fgetl(f); %read first line of the text file
    
    if (length(strfind(header, ';')) > 0)
        CONST.columnDivider = ';';
    elseif (length(strfind(header, ',')) > 0)
        CONST.columnDivider = ',';
    else
        disp('Error in the Header.');
    end
            
    
    s_comp = splitString(header,CONST.columnDivider);
    
    % Load data from the .dat file that has been created with the script.
    data = load([filename '.dat']);
   
    % To find the pattern associated with variables in header
    
    %%%%
    %Date Time
    if any(find(strcmp(CONST.DateTime_keyword, s_comp)))    
        CONST.DateTime_keyword = s_comp{find(strcmp(CONST.DateTime_keyword, s_comp))};
    else
        CONST.DateTime_keyword =''; 
    end
    
    %%%%
    %Vel
    if any(find(strcmp(CONST.Vel1_keyword, s_comp)))    
        CONST.Vel1_keyword = s_comp{find(strcmp(CONST.Vel1_keyword, s_comp))};
    else
        CONST.Vel1_keyword =''; 
    end
    
    if any(find(strcmp(CONST.Vel2_keyword, s_comp)))    
        CONST.Vel2_keyword = s_comp{find(strcmp(CONST.Vel2_keyword, s_comp))};
    else
        CONST.Vel2_keyword =''; 
    end
    
    %%%%
    %PAP
    if any(find(strcmp(CONST.PAP_keyword, s_comp)))    
        CONST.PAP_keyword = s_comp{find(strcmp(CONST.PAP_keyword, s_comp))};
    else
        CONST.PAP_keyword ='';
    end
    
    %%%%
    %Pressures
    if any(find(strcmp(CONST.PA1_keyword, s_comp)))    
        CONST.PA1_keyword = s_comp{find(strcmp(CONST.PA1_keyword, s_comp))};
    else
        CONST.PA1_keyword ='';
    end
    
    if any(find(strcmp(CONST.PA2_keyword, s_comp)))    
        CONST.PA2_keyword = s_comp{find(strcmp(CONST.PA2_keyword, s_comp))};
    else
        CONST.PA2_keyword ='';
    end
    
    if any(find(strcmp(CONST.PA3_keyword, s_comp)))    
        CONST.PA3_keyword = s_comp{find(strcmp(CONST.PA3_keyword, s_comp))};
    else
        CONST.PA3_keyword ='';
    end
    
    if any(find(strcmp(CONST.CVP_keyword, s_comp)))    
        CONST.CVP_keyword = s_comp{find(strcmp(CONST.CVP_keyword, s_comp))};
    else
        CONST.CVP_keyword ='';
    end
    
    if any(find(strcmp(CONST.ICP_keyword, s_comp)))    
        CONST.ICP_keyword = s_comp{find(strcmp(CONST.ICP_keyword, s_comp))};
    else
        CONST.ICP_keyword ='';
    end
    
    %%%%
    %ECG
    if any(find(strcmp(CONST.ECG_I_keyword, s_comp)))    
        CONST.ECG_I_keyword = s_comp{find(strcmp(CONST.ECG_I_keyword, s_comp))};
    else
        CONST.ECG_I_keyword ='';
    end
    
    if any(find(strcmp(CONST.ECG_II_keyword, s_comp)))    
        CONST.ECG_II_keyword = s_comp{find(strcmp(CONST.ECG_II_keyword, s_comp))};
    else
        CONST.ECG_II_keyword ='';
    end
    
    if any(find(strcmp(CONST.ECG_III_keyword, s_comp)))    
        CONST.ECG_III_keyword = s_comp{find(strcmp(CONST.ECG_III_keyword, s_comp))};
    else
        CONST.ECG_III_keyword ='';
    end
    
    if any(find(strcmp(CONST.ECGII_compound_keyword, s_comp)))    
        CONST.ECGII_compound_keyword = s_comp{find(strcmp(CONST.ECGII_compound_keyword, s_comp))};
    else
        CONST.ECGII_compound_keyword ='';
    end
    
    if any(find(strcmp(CONST.ECGV_compound_keyword, s_comp)))    
        CONST.ECGV_compound_keyword = s_comp{find(strcmp(CONST.ECGV_compound_keyword, s_comp))};
    else
        CONST.ECGV_compound_keyword ='';
    end
    
    if any(find(strcmp(CONST.MCL_keyword, s_comp)))    
        CONST.MCL_keyword = s_comp{find(strcmp(CONST.MCL_keyword, s_comp))};
    else
        CONST.MCL_keyword ='';
    end
      
    if any(find(strcmp(CONST.ECGaVR_compound_keyword, s_comp)))    
        CONST.ECGaVR_compound_keyword = s_comp{find(strcmp(CONST.ECGaVR_compound_keyword, s_comp))};
    else
        CONST.ECGaVR_compound_keyword ='';
    end
    
    if any(find(strcmp(CONST.ECG_V_keyword, s_comp)))    
        CONST.ECG_V_keyword = s_comp{find(strcmp(CONST.ECG_V_keyword, s_comp))};
    else
        CONST.ECG_V_keyword ='';
    end
      
    %%%%
    %CO2
    if any(find(strcmp(CONST.CO2_keyword, s_comp)))    
        CONST.CO2_keyword = s_comp{find(strcmp(CONST.CO2_keyword, s_comp))};
    else
        CONST.CO2_keyword ='';
    end
    
    %%%%
    %Plethysmo
    if any(find(strcmp(CONST.Pleth_keyword, s_comp)))    
        CONST.Pleth_keyword = s_comp{find(strcmp(CONST.Pleth_keyword, s_comp))};
    else
        CONST.Pleth_keyword ='';
    end
    
    %%%%
    %Cerveau
    if any(find(strcmp(CONST.EEG_keyword, s_comp)))    
        CONST.EEG_keyword = s_comp{find(strcmp(CONST.EEG_keyword, s_comp))};
    else
        CONST.EEG_keyword ='';
    end
    
    if any(find(strcmp(CONST.CrbVol_keyword, s_comp)))    
        CONST.CrbVol_keyword = s_comp{find(strcmp(CONST.CrbVol_keyword, s_comp))};
    else
        CONST.CrbVol_keyword ='';
    end
    
    %%%%
    %Respirateur
    if any(find(strcmp(CONST.AWP_keyword, s_comp)))    
        CONST.AWP_keyword = s_comp{find(strcmp(CONST.AWP_keyword, s_comp))};
    else
        CONST.AWP_keyword ='';
    end
    
    if any(find(strcmp(CONST.AWF_keyword, s_comp)))    
        CONST.AWF_keyword = s_comp{find(strcmp(CONST.AWF_keyword, s_comp))};
    else
        CONST.AWF_keyword ='';
    end
       
    if any(find(strcmp(CONST.AWRes_keyword, s_comp)))    
        CONST.AWRes_keyword = s_comp{find(strcmp(CONST.AWRes_keyword, s_comp))};
    else
        CONST.AWRes_keyword ='';
    end
   
    if any(find(strcmp(CONST.FeO2_keyword, s_comp)))    
        CONST.FeO2_keyword = s_comp{find(strcmp(CONST.FeO2_keyword, s_comp))};
    else
        CONST.FeO2_keyword ='';
    end
    
    
    %%%%
    %Divers
    if any(find(strcmp(CONST.UAP_keyword, s_comp)))    
        CONST.UAP_keyword = s_comp{find(strcmp(CONST.UAP_keyword, s_comp))};
    else
        CONST.UAP_keyword ='';
    end
    
    if any(find(strcmp(CONST.Elapsed_keyword, s_comp)))    
        CONST.Elapsed_keyword = s_comp{find(strcmp(CONST.Elapsed_keyword, s_comp))};
    else
        CONST.Elapsed_keyword ='';
    end
       
    
    %%%%
    %Define the column of respective headers
    for i = 1:length(s_comp)
        switch s_comp{i}
            case CONST.Vel1_keyword; Vel1Col = i
            case CONST.Vel2_keyword; Vel2Col = i
            case CONST.PAP_keyword; PAPCol = i
            case CONST.PA1_keyword; PA1Col = i
            case CONST.PA2_keyword; PA2Col = i
            case CONST.PA3_keyword; PA3Col = i
            case CONST.CVP_keyword; CVPCol = i
            case CONST.ICP_keyword; ICPCol = i
            case CONST.ECG_V_keyword; ECG_VCol = i
            case CONST.MCL_keyword; MCLCol = i
            case CONST.ECGII_compound_keyword; CompoundIICol = i
            case CONST.ECGaVR_compound_keyword; CompoundaVRCol = i
            case CONST.ECGV_compound_keyword; CompoundVCol = i
            case CONST.ECG_I_keyword; ECG_ICol = i
            case CONST.ECG_III_keyword; ECG_IIICol = i
            case CONST.ECG_II_keyword; ECG_IICol = i
            case CONST.ECG_V_keyword; ECG_VCol = i
            case CONST.CO2_keyword; CO2Col = i
            case CONST.Pleth_keyword; PlethCol = i
            case CONST.Elapsed_keyword; ElapsedCol = i
            case CONST.FeO2_keyword; FeO2Col = i
            case CONST.UAP_keyword; UAPCol = i
            case CONST.CrbVol_keyword; CrbVolCol = i
            case CONST.AWF_keyword; AWFCol = i
            case CONST.AWP_keyword; AWPCol = i
            case CONST.AWRes_keyword; AWResCol = i
            case CONST.DateTime_keyword; DateTimeCol = i
        end
    end
       
        if ~isempty(DateTimeCol) 
            dataWholeRecord.DateTime = data(:,DateTimeCol); 
        end
        
        if ~isempty(Vel1Col) 
            dataWholeRecord.Vel1 = data(:,Vel1Col);
        end
        
        if ~isempty(Vel2Col) 
            dataWholeRecord.Vel2 = data(:,Vel2Col); 
        end
        
        if ~isempty(PA1Col) 
            dataWholeRecord.PA1 = data(:,PA1Col); 
        end
        
        if ~isempty(PA2Col) 
            dataWholeRecord.PA2 = data(:,PA2Col); 
        end
        
        if ~isempty(PA3Col) 
            dataWholeRecord.PA3 = data(:,PA3Col); 
        end
        
        if ~isempty(PAPCol) 
            dataWholeRecord.PAP = data(:,PAPCol); 
        end
        
        if ~isempty(ECG_ICol) 
            dataWholeRecord.ECG_I = data(:,ECG_ICol); 
        end
        
        if ~isempty(ECG_IICol) 
            dataWholeRecord.ECG_II = data(:,ECG_IICol); 
        end
        
        if ~isempty(ECG_IIICol) 
            dataWholeRecord.ECG_III = data(:,ECG_IIICol); 
        end
        
        if ~isempty(ECG_VCol) 
            dataWholeRecord.ECG_V = data(:,ECG_VCol); 
        end
        
        if ~isempty(CompoundIICol) 
            dataWholeRecord.CompoundII = data(:,CompoundIICol);  
        end
        
        if ~isempty(CompoundVCol)
            dataWholeRecord.CompoundV = data(:,CompoundVCol);
        end
        
        if ~isempty(CompoundaVRCol)
            dataWholeRecord.CompoundaVR = data(:,CompoundaVRCol);
        end
        
        if ~isempty(CO2Col)
            dataWholeRecord.CO2 = data(:,CO2Col);
        end
        
        if ~isempty(EEGCol)
            dataWholeRecord.EEG = data(:,EEGCol);
        end
        
        if ~isempty(AWPCol)
            dataWholeRecord.AWP = data(:,AWPCol);
        end
        
        if ~isempty(AWFCol)
            dataWholeRecord.AWF = data(:,AWFCol);
        end
        
        if ~isempty(AWResCol)
            dataWholeRecord.AWRes = data(:,AWResCol);
        end
        
        if ~isempty(ICPCol)
            dataWholeRecord.ICP = data(:,ICPCol);
        end
        
        if ~isempty(CVPCol)
            dataWholeRecord.CVP = data(:,CVPCol);
        end
        
        if ~isempty(FeO2Col)
            dataWholeRecord.FeO2 = data(:,FeO2Col);
        end
        
        if ~isempty(CrbVolCol)
            dataWholeRecord.CrbVol = data(:,CrbVolCol);
        end
        
        if ~isempty(UAPCol)
            dataWholeRecord.UAP = data(:,UAPCol);
        end
        
        if ~isempty(ElapsedCol)
            dataWholeRecord.Elapsed = data(:,ElapsedCol);
        end
        
        if ~isempty(MCLCol)
            dataWholeRecord.MCL = data(:,MCLCol);
        end
        
        if ~isempty(PlethCol)
            dataWholeRecord.Pleth = data(:,PlethCol);
        end
        
   
% if ~isempty(dataWholeRecord.Vel1) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PA1); 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.Vel1 / max(abs(dataWholeRecord.Vel1)));
%     hold on; 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PAP / max(abs(dataWholeRecord.PAP)));
%     hold on;
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PA1 / max(abs(dataWholeRecord.PA1)));
% end

% if ~isempty(dataWholeRecord.Vel1) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PA2); 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.Vel1 / max(abs(dataWholeRecord.Vel1)));
%     hold on; 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PAP / max(abs(dataWholeRecord.PAP)));
%     hold on;
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PA2 / max(abs(dataWholeRecord.PA2)));
% end

% if ~isempty(dataWholeRecord.Vel1) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PAP) && ~isempty(dataWholeRecord.PA3); 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.Vel1 / max(abs(dataWholeRecord.Vel1)));
%     hold on; 
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PAP / max(abs(dataWholeRecord.PAP)));
%     hold on;
%     plot(dataWholeRecord.DateTime,dataWholeRecord.PA3 / max(abs(dataWholeRecord.PA3)));
% end


% Transfert=Transfert';
% [nrows,ncols] = size(Transfert);
% fileID = fopen('celldata.dat','w');
% formatSpec = '%4s\n%';
% for row = 1:nrows
%     fprintf(fileID,formatSpec,Transfert{row,:});
% end
% fclose(fileID);
% type celldata.dat

end
