# -*- coding: utf-8 -*-



result_file = open(r'H:\FJP\scripts\corrigido.txt','w') #endereço onde será salvo o arquivo corrigido
primeira_linha = True

with open(r'D:\Downloads\xaa.txt', errors=('ignore') ) as f: #endereço onde o arquivo original está salvo
    for line in f: 
                  
        if(primeira_linha):
            if(line.find("CUF;") != -1):
                primeira_linha = False
                continue  
            
        posicao = [pos for pos, char in enumerate(line) if char == '"']          
        for i in range(1, round(len(posicao)/2)+1):
            if(line.count(';', posicao[i*2-2], posicao[i*2-1]) >= 1):
                pos_ponto_virgula = [pos for pos, char in enumerate(line) if char == ';']
                for j in range(0, len(pos_ponto_virgula)):    
                    if ((posicao[i*2-2] < pos_ponto_virgula[j]) and (posicao[i*2-1] > pos_ponto_virgula[j])):                    
                        line = line[:pos_ponto_virgula[j]] + ',' + line[pos_ponto_virgula[j]+1:]
        if line.count(';') < 24:
            aux_pos = line.find('6102,')
            line = line[:aux_pos+4] + ';' + line[aux_pos+5:]
            
        result_file.write(line)  
    
        
        
      
result_file.close()

        
