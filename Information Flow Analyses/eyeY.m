function Y=eyeY(Y)
% last updated: July 26, 2019
for i=1:size(Y,1)
    for j=1:size(Y,2)
        if i==j
            for k=1:size(Y,3)
                Y(i,j,k)=nan;
            end
        end
    end
end