function [decoa,deco_mat]=ww_decoding_dir(cSpike,indM,bin_cen,stimdir,varargin)
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
% uNeuron:   uNeuron: vector of each neuron to X matrix. outside: trials x bins; inside: neurons x choice (left/right)
%__________________________________________________________________________

numG=length(indM);
for g=1:length(bin_cen)
    decom=[];
    Matrix=[]; % neuron x trial matrrix
    for i=1:numG
        Matrix{1,i}=cSpike(:,indM{i},g);
    end
    
    tinr=0;
    for n=1:numG
        ind=indM{n};
        for o=1:length(ind)
            tinr=tinr+1;
            triind=ind(o);%%trial index
            tMatrix=Matrix;%(stimdir(triind,:));
            X= tMatrix{1,n}(:,o); % X: the trials selected to do decoding
            tMatrix{1,n}(:,o)=[]; % exclude trial X
            sX=[];edis=nan(1,2);
            
            for p= stimdir(triind,:)% in what & where task, only has two chioce options
                sX{p}=X-nanmean(tMatrix{1,p},2);
                edis(1,p)=norm(sX{p}(~isnan(sX{p}))); %euclidean distance
            end
            
            [~, ii]=min(edis,[],2); %% decoding choice
            
            pdir=exp(-(edis).^2);
            ppdir=pdir/sum(pdir); % choice probability
            
            decom(tinr,1)=triind; %trial number
            decom(tinr,2) = ii==n; % whether match
            decom(tinr,3)= n; %% monkey chosen
            decom(tinr,4)=ii; %% decoding chosen
            decom(tinr,5:4+numG*2)=[edis, ppdir]; %distance to each group & choice probability
            
%             for z=1:size(sX,2)
%                 u{tinr,1}(:,z)=sX{z}; u{tinr,1}(:,z)=sX{z};
%             end
            
            clear tMatrix edis pdir ppdir
        end
    end
    decoa(g)=nanmean(decom(:,2)); % average of decoding
    deco_mat{1,g}=sortrows(decom,1); % deco Matrix
    
    [deco_mat{1,g},index] =sortrows(decom,1);
%     uNeuron(:,g)= u(index,1);
    % uNeuron: vector of each neuron to X matrix. outside: trials x bins; inside: neurons x choice (left/right)
end
end