from openpyxl import Workbook, load_workbook
from openpyxl.styles import Font, Alignment
import json
import csv

alunos = []

def cadastrar_alunos_csv(arq: str, rm: str, nome: str, cp1: float, cp2: float, cp3: float) -> None:
    try:
        with open(arq + ".csv", "a", newline="", encoding="utf-8") as arquivo:
            gravador = csv.writer(arquivo, delimiter=",")
            gravador.writerow([rm, nome, cp1, cp2, cp3])

    except OSError as erro:
        print(f"Erro ao ler o arquivo: {erro}")

def gravar_cabecalho_csv(arq: str) -> None:
    with open(arq + ".csv", "a", newline="", encoding="utf-8") as arquivo:
        gravador = csv.writer(arquivo, delimiter=",")
        gravador.writerow(["RM","Nome","CP1","CP2","CP3"])


def verificar_json() -> None:
    try:
        with open("pessoa.json", "r", encoding="utf-8"):
            return True

    except FileNotFoundError:
        return False

def cadastrar_alunos_json(arq: str, rm: str, nome: str, cp1: float, cp2: float, cp3: float) -> None:
    alunos = []
    aluno = {
        "rm": rm,
        "nome": nome,
        "cp1": cp1,
        "cp2": cp2,
        "cp3": cp3
    }

    alunos.append(aluno)

    with open(arq + ".json", "w", encoding="utf-8") as arquivo:
        json.dump(alunos, arquivo, indent=4)

def cadastrar_alunos_txt(arq: str, rm: str, nome: str, cp1: float, cp2: float, cp3: float) -> None:
    try:
        with open(arq + ".txt", "a", encoding="utf-8") as arquivo:
            arquivo.write(f"{rm},{nome},{cp1},{cp2},{cp3}\n")
    except OSError as erro:
        print(f"Erro ao ler o arquivo: {erro}")

def gravar_cabecalho_txt(arq) -> None:
    with open(arq + ".txt", "a", encoding="utf-8") as arquivo:
        arquivo.write(f"RM,Nome,CP1,CP2,CP3\n")

def cadastrar_alunos_excel(arq: str, rm: str, nome: str, cp1: float, cp2: float, cp3: float) -> None:
    try:
        planilha = Workbook()
        aba = planilha.active
        aba.title = "Alunos"

        aba["A1"] = "RM"
        aba["B1"] = "NOME"
        aba["C1"] = "CP1"
        aba["D1"] = "CP2"
        aba["E1"] = "CP2"

        aba["A2"] = rm
        aba["B2"] = nome
        aba["C2"] = cp1
        aba["D2"] = cp2
        aba["E2"] = cp3

        for celula in aba[1]:
            celula.font = Font(bold = True)
            celula.alignment = Alignment(horizontal="center")

        planilha.save("alunos.xlsx")

    except OSError as erro:
        print(f"Erro ao ler o arquivo: {erro}")


def listar_alunos_csv(arq: str) -> None:
    try:
        with open(arq + ".csv", "r", newline="", encoding="utf-8") as arquivo:
            leitor = csv.reader(arquivo, delimiter=",")
            for linha in leitor:
                aluno = {
                    "rm": linha[0],
                    "nome": linha[1],
                    "cp1": linha[2],
                    "cp2": linha[3],
                    "cp3": linha[4]
                }

                alunos.append(aluno)
            
    except FileNotFoundError:
        print("O arquivo não existe")

def exibir_csv() -> str:
    for aluno in alunos:
        print(f"RM: {aluno['rm']}")
        print(f"Nome: {aluno['nome']}")
        print(f"CP1: {aluno['cp1']}")
        print(f"CP2: {aluno['cp2']}")
        print(f"CP3: {aluno['cp3']}")

def listar_json(a: list, b: list, c: list, d: list) -> list:
    try:
        with open("pessoa.json", "r", encoding="utf-8") as arquivo:
            pessoas = json.load(arquivo)

        for pessoa in pessoas:
            a = pessoa["cpf"] 
            b = pessoa["nome"] 
            c = pessoa["endereco"] 
            d = pessoa["celular"]
            return a, b, c, d

    except FileNotFoundError:
        print("O arquivo não existe!")

def listar_txt() -> None:
    try:
        with open("pessoa.txt", "r", encoding="utf-8") as arquivo:
            for linha in arquivo: # Percorre as linhas do arquivo
                lista = linha.split(",")
                print(f"CPF: {lista[0]}")
                print(f"Nome: {lista[1]}")
                print(f"Endereço: {lista[2]}")
                print(f"Celular: {lista[3]}")
    except FileNotFoundError:
        print("O arquivo não existe!")