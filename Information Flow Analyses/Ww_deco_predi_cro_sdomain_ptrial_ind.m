function [decoM]= Ww_deco_predi_cro_sdomain_ptrial_ind(pdecoM,ttrials)
%% extract partial trials to do decoding

tdtrial=pdecoM{1, 1}{1, 201}(:,1); % trials in current block
otrial=intersect(tdtrial,ttrials);

[~,loc]=ismember(otrial,tdtrial);

for j=1:length(pdecoM)
    for k=1:length(pdecoM{1,1})
        decoM{1,j}{1, k} = pdecoM{1,j}{1, k}(loc,:);
    end
end