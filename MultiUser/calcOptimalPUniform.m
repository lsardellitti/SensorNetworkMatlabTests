function PVals = calcOptimalPUniform(N0, N, pBar, P1)
    PVals = zeros(N,1);
    PVals(1) = P1;
    for i = 2:N
        word = ones(1, N-1);
        word1 = [1 word];
        word2 = [0 word];
        word3 = [1 word];
        word4 = [0 word];
        word1(i) = 1;
        word2(i) = 0;
        word3(i) = 0;
        word4(i) = 1;
        ind1 = bin2dec(num2str(word1))+1;
        ind2 = bin2dec(num2str(word2))+1;
        ind3 = bin2dec(num2str(word3))+1;
        ind4 = bin2dec(num2str(word4))+1;
        PVals(i) = log(pBar(ind1)*pBar(ind2)/(pBar(ind3)*pBar(ind4)))*N0/(8*P1);
    end
end

