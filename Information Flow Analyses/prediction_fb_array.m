function [shVar,ohVar]=prediction_fb_array(Y,aGroup)


shVar{1,1}=[]; shVar{1,2}=[]; shVar{1,3}=[];
shVar{2,1}=[]; shVar{2,2}=[]; shVar{2,3}=[];
shVar{3,1}=[];

ohVar{1,1}=[]; ohVar{1,2}=[]; ohVar{1,3}=[];
ohVar{2,1}=[]; ohVar{2,2}=[]; ohVar{2,3}=[];
ohVar{3,1}=[];

for i=1:size(Y,1)
    [row,col] = find(aGroup==i);
    
    %%% same hemisphere: -, anterior
    if ismember(i-1,aGroup(row,:))
        shVar{1,1}=[shVar{1,1}; Y{i-1,i,:}];
    end
    
    if ismember(i-2,aGroup(row,:))
        shVar{1,2}=[shVar{1,2};  Y{i-2,i,:}];
    end
    
    if ismember(i-3,aGroup(row,:))
        shVar{1,3}=[shVar{1,3};  Y{i-3,i,:}];
    end
    
    %%% same hemisphere: +, posterior
    if ismember(i+1,aGroup(row,:))
        shVar{2,1}=[shVar{1,1};  Y{i+1,i,:}];
    end
    
    if ismember(i+2,aGroup(row,:))
        shVar{2,2}=[shVar{1,2}; Y{i+2,i,:}];
    end
    
    if ismember(i+3,aGroup(row,:))
        shVar{2,3}=[shVar{1,3}; Y{i+3,i,:}];
    end
    
    %% same location at opposite hemisphere
    shVar{3,1}=[shVar{3,1}; Y{i,i,:}];
    
    %%% opposite hemisphere: -, anterior
    if ismember(i-1,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-1);
        ohVar{1,1}=[ohVar{1,1}; Y{tt,i,:}];
    end
    
    if ismember(i-2,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-2);
        ohVar{1,2}=[ohVar{1,2}; Y{tt,i,:}];
    end
    
    if ismember(i-3,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-3);
        ohVar{1,3}=[ohVar{1,3}; Y{tt,i,:}];
    end
    
    %%% opposite hemisphere: +, posterior
    if ismember(i+1,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+1);
        ohVar{2,1}=[ohVar{2,1}; Y{tt,i,:}];
    end
    
    if ismember(i+2,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+2);
        ohVar{2,2}=[ohVar{2,2}; Y{tt,i,:}];
    end
    
    if ismember(i+3,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+3);
        ohVar{2,3}=[ohVar{2,3}; Y{tt,i,:}];
    end
    
    %% same location at opposite hemisphere
    ttt=aGroup(setdiff([1,2],row),col);
    ohVar{3,1}=[ohVar{3,1}; Y{ttt,i,:}];
end
end