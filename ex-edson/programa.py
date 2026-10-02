import os
os.system("cls")
from subalgoritmos import *

arq = "alunos"

while True:
    print(28 * '-')
    print("""
    MENU PRINCIPAL
    0 - SAIR
    1 - Gravar alunos
    2 - Ler arquivo
    """)

    escolha = input("Escolha: ")

    match escolha:
        case '0':
            break
        case '1':
            rm = input("RM: ")

            gravar_cabecalho_csv(arq)
            gravar_cabecalho_txt(arq)
            
            while rm == "":
                print("O campo não pode ser vazio!")
                rm = input("RM: ")

            while rm != "":
                nome = input("Nome: ")
                cp1 = float(input("CP1: "))
                cp2 = float(input("CP2: "))
                cp3 = float(input("CP3: "))

                cadastrar_alunos_csv(arq, rm, nome, cp1, cp2, cp3)
                cadastrar_alunos_txt(arq, rm, nome, cp1, cp2, cp3)
                cadastrar_alunos_json(arq, rm, nome, cp1, cp2, cp3)
                cadastrar_alunos_excel(arq, rm, nome, cp1, cp2, cp3)
                rm = input("RM: ")

                    
        case '2':
            print(20 * '-')
            print("""
1 - Texto
2 - CSV
3 - JSON
4 - Excel
""")
            dados = input("Escolha: ")
            match dados:
                case '1':
                    pass
                case '2':
                    listar_alunos_csv(arq)
                    exibir_csv()
                case '3':
                    pass
                case '4':
                    pass