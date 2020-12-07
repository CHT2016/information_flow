function [numM,pnumM]=neuron_index_compare(whatInd,whereInd)
%__________________________________________________________________________
% neuron_index_compare.m - comparing significant neurons index between
% tasks and obj/dir encoding.
% Last update: September 27, 2019
% Hua Tang,Postdoc of Dr. Averbeck Lab @NIMH.
%__________________________________________________________________________
% INPUT
% whatInd:      2 x 4 (group) Cellarry with elements arrange as neurons x bins matrix.
% whereInd:     2 x 4 (group) Cellarry with elements arrange as neurons x bins matrix.
%
% OUTPUT
% numM:   number of overlap neurons.
% pnumM:  propertion of overlap neurons.2 x 4 (group) Cellarry with elements
%         arrange as neurons x bins matrix. formula: 2*overlap/(group1 + group2)
%__________________________________________________________________________

Mat11=whatInd.dir;
Mat12=whatInd.obj;
Mat21=whereInd.dir;
Mat22=whereInd.obj;
for i=1:size(Mat11,1)
    for j=1:size(Mat11,2)
        numM{i,j}(1,:)=nansum(Mat11{i,j}==1 & Mat12{i,j}==1); % what.dir//what.obj
        numM{i,j}(2,:)=nansum(Mat11{i,j}==1 & Mat21{i,j}==1);% what.dir//where.dir
        numM{i,j}(3,:)=nansum(Mat11{i,j}==1 & Mat22{i,j}==1);% what.dir//where.obj
        numM{i,j}(4,:)=nansum(Mat12{i,j}==1 & Mat21{i,j}==1);% what.obj//where.dir
        numM{i,j}(5,:)=nansum(Mat12{i,j}==1 & Mat22{i,j}==1);% what.obj//where.obj
        numM{i,j}(6,:)=nansum(Mat21{i,j}==1 & Mat22{i,j}==1);% where.dir//where.obj
        
        numM{i,j}(7,:)=nansum(Mat11{i,j});
        numM{i,j}(8,:)=nansum(Mat12{i,j});
        numM{i,j}(9,:)=nansum(Mat21{i,j});
        numM{i,j}(10,:)=nansum(Mat22{i,j});
        
        % fractions
        % % %         pnumM{i,j}(1,:)=nansum(Mat11{i,j}==1 & Mat12{i,j}==1)/size(Mat11{i,j},1);
        % % %         pnumM{i,j}(2,:)=nansum(Mat11{i,j}==1 & Mat21{i,j}==1)/size(Mat11{i,j},1);
        % % %         pnumM{i,j}(3,:)=nansum(Mat11{i,j}==1 & Mat22{i,j}==1)/size(Mat11{i,j},1);
        % % %         pnumM{i,j}(4,:)=nansum(Mat12{i,j}==1 & Mat21{i,j}==1)/size(Mat11{i,j},1);
        % % %         pnumM{i,j}(5,:)=nansum(Mat12{i,j}==1 & Mat22{i,j}==1)/size(Mat11{i,j},1);
        % % %         pnumM{i,j}(6,:)=nansum(Mat21{i,j}==1 & Mat22{i,j}==1)/size(Mat11{i,j},1);
        
        pnumM{i,j}(1,:)=2*nansum(Mat11{i,j}==1 & Mat12{i,j}==1)./(nansum(Mat11{i,j})+nansum(Mat12{i,j}));
        pnumM{i,j}(2,:)=2*nansum(Mat11{i,j}==1 & Mat21{i,j}==1)./(nansum(Mat11{i,j})+nansum(Mat21{i,j}));
        pnumM{i,j}(3,:)=2*nansum(Mat11{i,j}==1 & Mat22{i,j}==1)./(nansum(Mat11{i,j})+nansum(Mat22{i,j}));
        pnumM{i,j}(4,:)=2*nansum(Mat12{i,j}==1 & Mat21{i,j}==1)./(nansum(Mat12{i,j})+nansum(Mat21{i,j}));
        pnumM{i,j}(5,:)=2*nansum(Mat12{i,j}==1 & Mat22{i,j}==1)./(nansum(Mat12{i,j})+nansum(Mat22{i,j}));
        pnumM{i,j}(6,:)=2*nansum(Mat21{i,j}==1 & Mat22{i,j}==1)./(nansum(Mat21{i,j})+nansum(Mat22{i,j}));
    end
end
end