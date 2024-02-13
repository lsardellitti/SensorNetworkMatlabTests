function [linePoints] = calculateLineBound(PVals, PVar, PRel, A, N0, N, pBar, P, points)
    linePoints = [];
    for i = 0:1
        for j = 0:2^(N-2)-1 
            if N>2
                currWord = dec2bin(j,N-2)-'0';
            else
                currWord = [];
            end
            currWord = [currWord(1:min(PVar,PRel)-1) 0 currWord(min(PVar,PRel):end)];
            if max(PVar,PRel) < N
                currWord = [currWord(1:max(PVar,PRel)-1) 0 currWord(max(PVar,PRel):end)];
            else
                currWord = [currWord 0]; %#ok<AGROW>
            end
            currWord(PVar) = i;
            word0 = currWord;
            word0(PRel) = 0;
            word1 = currWord;
            word1(PRel) = 1;
            ind0 = bin2dec(num2str(word0))+1;
            ind1 = bin2dec(num2str(word1))+1;
            offset = -(N0/(2*(A(2)-A(1))*P(PRel)))*log(pBar(ind1)/-pBar(ind0))+sum(A)*P(PRel)/2+points(ind0)-A(i+1)*P(PVar)-A(1)*P(PRel);
            if ~isreal(offset)
                continue
            end
            linePoints = [linePoints; PVals*A(i+1) + offset]; %#ok<AGROW>
        end
    end
end