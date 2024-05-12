# -*- coding: utf-8 -*-


result_file = open(r'H:\FJP\scripts\xaa.txt','w') #endereço onde será salvo o arquivo corrigido

with open(r'D:\Downloads\xab.txt', errors=('ignore') ) as f: #endereço onde o arquivo original está salvo
    for line in f: 
                      
        if line.count(';') > 24:        
            posicao = [pos for pos, char in enumerate(line) if char == '"']          
            
          
            for i in range(1, round(len(posicao)/2)+1):
                pos_ponto_virgula = [pos for pos, char in enumerate(line) if char == ';']
                for j in range(0, len(pos_ponto_virgula)):    
                    if ((posicao[i*2-2] < pos_ponto_virgula[j]) and (posicao[i*2-1] > pos_ponto_virgula[j])):                    
                         line = line[:pos_ponto_virgula[j]] + ',' + line[pos_ponto_virgula[j]+1:]
        
        result_file.write(line)
      
result_file.close()

        
