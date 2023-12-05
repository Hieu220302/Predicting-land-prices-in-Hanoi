function [data] = STE(frames )
%tinh nang luong ngan han Short-Term Energy cua tin hieu
    data = zeros(size(frames,1),1);%khoi tao ham nang luong ngan han
    for i = 1:size(frames,1)
        data(i) = sum(frames(i,:).^2); %cong thuc cs425
    end
end