# -*- coding: utf-8 -*-

nova_lista = []

result_file = open(r'H:\FJP\scripts\xaa.txt','w') #endereço onde será salvo o arquivo corrigido

with open(r'D:\Downloads\xad.txt' ) as f: #endereço onde o arquivo original está salvo
    for line in f: 
                      
        if line.count(';') > 24:        
            posicao = [pos for pos, char in enumerate(line) if char == '"']
           
            
            pos_pontovirgula = []
            for i in range(1, round(len(posicao)/2)+1):
                aux_pos = line.find(';', posicao[i*2-2], posicao[i*2-1])
                pos2 = [pos for pos, char in enumerate(line[posicao[i*2-2]: posicao[i*2-1]]) if char == ';']
                print(pos2)
                if aux_pos != -1:
                    pos_pontovirgula.append(aux_pos)
                    
    
            for i in range(0, len(pos_pontovirgula)):    
                line = line[:pos_pontovirgula[i]] + ',' + line[pos_pontovirgula[i]+1:]
        
        result_file.write(line)
      
result_file.close()

        
