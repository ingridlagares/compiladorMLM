#ifndef SYMTAB_H
#define SYMTAB_H

typedef enum Tipo {
    _int, _real, _bool, _char
} Tipo;

int escopo[10];
int TabHash[509];
int nivel; /* inteiro que contem o numero do nivel atual */
int L;     /* inteiro que contem o indice do ultimo elemento da Tabela
              de Simbolos */
int Raiz;  /* inteiro que contem o indice do primeiro elemento da Tabela
              de Simbolos */

struct {
    char nome[10];       /* Contem o nome do Simbolo */
    int  nivel;          /* Contem o nivel do Simbolo relacionado */
    char atributo[10];   /* Contem o atributo do  relacionado */
    int col;
    Tipo tipo;
} TabelaS[100]; /* Vetor de struct que contem a tabela de
                   simbolos */

int Hashing(char chave[10]);
void In_Block(void);
void Error(int numero);
void Out_Block(void);
int  Get_Entry(char name[10]);
void Insert(char name[10], char atributo[10], Tipo tipo);
void Print_Table(void);

#endif
