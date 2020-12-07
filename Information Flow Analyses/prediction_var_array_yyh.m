function [shdy,ohdy]=prediction_var_array_yyh(ty,aGroup)

for m=1:size(ty,2)
    for o=1:8 % 1:8 arrary
        for n=1:size(ty{1},3)
            fmpy{1,m}(o,:,n)=ty{1,m}(10,:,n)-ty{1,m}(o,:,n);
        end
        mfmpy{1,m}=mean(fmpy{1,m},3);
    end
end

shdy{1,1}=[]; shdy{1,2}=[]; shdy{1,3}=[];
shdy{2,1}=[]; shdy{2,2}=[]; shdy{2,3}=[];
shdy{3,1}=[];

ohdy{1,1}=[]; ohdy{1,2}=[]; ohdy{1,3}=[];
ohdy{2,1}=[]; ohdy{2,2}=[]; ohdy{2,3}=[];
ohdy{3,1}=[];

for i=1:size(mfmpy,2)
    [row,col] = find(aGroup==i);
    
    %%% same hemisphere: -, anterior
    if ismember(i-1,aGroup(row,:))
        shdy{1,1}=[shdy{1,1}; squeeze(fmpy{1,i}(i-1,:,:))'];
    end
    
    if ismember(i-2,aGroup(row,:))
        shdy{1,2}=[shdy{1,2}; squeeze(fmpy{1,i}(i-2,:,:))'];
    end
    
    if ismember(i-3,aGroup(row,:))
        shdy{1,3}=[shdy{1,3}; squeeze(fmpy{1,i}(i-3,:,:))'];
    end
    
    %%% same hemisphere: +, posterior
    if ismember(i+1,aGroup(row,:))
        shdy{2,1}=[shdy{2,1}; squeeze(fmpy{1,i}(i+1,:,:))']
    end
    
    if ismember(i+2,aGroup(row,:))
        shdy{2,2}=[shdy{2,2}; squeeze(fmpy{1,i}(i+2,:,:))'];
    end
    
    if ismember(i+3,aGroup(row,:))
        shdy{2,3}=[shdy{2,3}; squeeze(fmpy{1,i}(i+3,:,:))'];
    end
    
    %%% same location at same hemisphere
    shdy{3,1}=[shdy{3,1}; squeeze(fmpy{1,i}(i,:,:))'];
    
    %%% opposite hemisphere: -, anterior
    if ismember(i-1,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-1);
        ohdy{1,1}=[ohdy{1,1}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    if ismember(i-2,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-2);
        ohdy{1,2}=[ohdy{1,2}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    if ismember(i-3,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col-3);
        ohdy{1,3}=[ohdy{1,3}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    %%% opposite hemisphere: +, posterior
    if ismember(i+1,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+1);
        ohdy{2,1}=[ohdy{2,1}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    if ismember(i+2,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+2);
        ohdy{2,2}=[ohdy{2,2}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    if ismember(i+3,aGroup(row,:))
        tt=aGroup(setdiff([1,2],row),col+3);
        ohdy{2,3}=[ohdy{2,3}; squeeze(fmpy{1,i}(tt,:,:))'];
    end
    
    %% same location at opposite hemisphere
    ttt=aGroup(setdiff([1,2],row),col);
    ohdy{3,1}=[ohdy{3,1}; squeeze(fmpy{1,i}(ttt,:,:))'];
end
end