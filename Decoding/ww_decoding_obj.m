function [decoa,deco_mat]=ww_decoding_obj(cSpike,indM,bin_cen,stimobj,gBlock,varargin)
%__________________________________________________________________________
% barplot_pair.m - plot figure with SEM Shadow with cell file.
% Last update: April 14, 2019
% Hua Tang,Postdoc of Dr. Averbeck Lab @NIMH.
%__________________________________________________________________________
% INPUT
%
% psth:      3D matrix PSTH data: neuron x trial x bins.
% indG:      group index: 1 x Group Cellarry with elements arrange as trial x 1 matrix.
% bin_edges: the edges of bin: numerical colums of 1 x bin length.
%
% OUTPUT
%
% decoa:     average of decoding result
% deco_mat:  decoding matrix:  1 x bin Cellarry with elements arrange as trial x n matrix.
%__________________________________________________________________________

numB=length(gBlock)-1;
for g=1:length(bin_cen)
    decom=[];
    
    tinr=0;
    for m=1:numB % in this codition, objects in each block were different.
        [row,~,~]=find(indM >= gBlock(m) & indM < gBlock(m+1));
        tindM=indM(row);
        [C,~,~]=unique(stimobj(indM(row)));
        indC=[];Matrix=[];
        
        if numel(C)==2
            indC{1}=intersect(find(stimobj==C(1)),tindM);
            indC{2}=intersect(find(stimobj==C(2)),tindM);
            Matrix{1,1}=cSpike(:,indC{1},g);
            Matrix{1,2}=cSpike(:,indC{2},g);
            
            for n=1:2
                ind=indC{n};
                for o=1:length(ind)
                    tinr=tinr+1;
                    triind=ind(o);%%trial index
                    tMatrix=Matrix;%(stimdir(triind,:));
                    X= tMatrix{1,n}(:,o); % X: the trials selected to do decoding
                    tMatrix{1,n}(:,o)=[]; % exclude trial X
                    sX=[];edis=nan(1,2);
                    
                    for p = 1:size(tMatrix,2)% stimobj(triind,:)% in what & where task, only has two chioce options
                        sX{p}=X-nanmean(tMatrix{1,p},2);
                        edis(1,p)=norm(sX{p}(~isnan(sX{p}))); %euclidean distance
                    end
                    
                    [~, ii]=min(edis,[],2); %% decoding choice
                    pdir=exp(-(edis).^2);
                    ppdir=pdir/sum(pdir); % choice probability
                    
                    decom(tinr,1)=triind; %trial number
                    decom(tinr,2) = ii==n; % whether match
                    decom(tinr,3)=n; %% monkey chosen
                    decom(tinr,4)=ii; %% decoding chosen
                    decom(tinr,5:4+size(tMatrix,2)*2)=[edis, ppdir]; %distance to each group & choice probability
                    clear tMatrix sX edis pdir ppdir
                end
            end
        else
        end
    end
    
    decoa(g)=nanmean(decom(:,2)); % average of decoding
    deco_mat{1,g}=sortrows(decom,1); % deco Matrix
end
end