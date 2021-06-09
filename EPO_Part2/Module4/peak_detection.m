function [R] = peak_detection(hhat,tolerance,position, Fs)
    maxDist = sqrt(max(position(1,:))^2 + max(position(2,:))^2);
    searRange = ceil(maxDist*Fs/34300);
    N=width(hhat);
    for i = 1:N-1
        for j = i+1:N
            pkloc = abs(hhat(:,i)) > tolerance*max(abs(hhat(:,i)));
            compVec1 = pkloc.*hhat(:,i);
            [~, pks1] = findpeaks(abs(compVec1));
            if pks1(1) <= searRange
                pkloc2 = abs(hhat(1:pks1(1)+searRange,j)) >...
                tolerance*max(abs(hhat(1:pks1(1)+searRange,j)));

                compVec2 = pkloc2.*hhat(1:pks1(1)+searRange,j);
                [~, pks2] = findpeaks(abs(compVec2));
            else
                pkloc2 = abs(hhat(pks1(1)-searRange:...
                pks1(1)+searRange,j)) > tolerance*max(abs(hhat(pks1(1)...
                -searRange:pks1(1)+searRange,j)));

                compVec2 = pkloc2.*hhat(pks1(1)-searRange:pks1(1)+searRange,j);
                [~, pks2] = findpeaks(abs(compVec2));
                pks2 = pks2 + pks1(1)-searRange;
            end
            R(i,j)=calcD(pks1(1),pks2(1),Fs); 
        end
    end
end