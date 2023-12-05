function [frames] = Framing(x,time,Fs)
   frames_size = time*Fs; %So mau moi khung
   numberOfFrame = floor(length(x)/frames_size); %So khung 
   frames = zeros(numberOfFrame,frames_size); % Tao khung (So khung, So mau)
   temp = 0;
   for i = 1:numberOfFrame
       frames(i,:) = x(temp+1:temp+frames_size); %1->N,N+1->2N,2N+1->3N
       temp = temp+frames_size;
   end
end
