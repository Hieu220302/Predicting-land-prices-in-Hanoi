function [data] = ZCR(frames )
    data = zeros(size(frames,1),1); 
    for i = 1:size(frames,1)
        sum = 0;
        for j = 2:length(frames(i,:))
            if(frames(i,j)*frames(i,j-1)<0)
            sum = sum + 1;
        end
        data(i) = sum;
    end 
         
end

