import jsonpickle 

personagem = {
   "nome"   : "Gandalf",
   "classe" : "Wizard",
   "ordem"  : "Istari"
}

for key in personagem: # Percorre os valores do dicionário
   print(personagem[key]) # Imprime os valores do dicionário
   
for chave,valor in personagem.items(): # Percorre as chaves e os valores
   print(f'{chave} : {valor}') # Imprime as chaves e os valores

for p in personagem.values(): # Percorre os valores do dicionário
   print(p) # Imprime os valores do dicionário

class Gato:
    def __init__(self, nome, raca):
        self.nome = nome 
        self.raca = raca


gato = Gato('Osíris','Sphynx')
print(gato.nome,  gato.raca)

jsonpickle.set_preferred_backend('json')
jsonpickle.set_encoder_options('json', ensure_ascii=False)
with open('gato.json', 'w') as file:
    frozen = jsonpickle.encode(gato)
    file.write(frozen)