#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"

#define NMax 10     /* Numero maximo de niveis possiveis */

int Hashing(char chave[10]) {
    int hash = 5381;
    int c;

    while (c = *chave++)
        hash = ((hash << 5) + hash) + c;

    return hash;
}

void Error(int num) {
    char opcao;
    switch (num) {
        case 1:
            printf("Tabela cheia\n"); 
            break;
        case 2:
            printf("Item nao encontrado\n"); 
            break;
        case 3:
            printf("Item ja inserido\n");
            break;
    }
}

void In_Block() {
    nivel++;
    if (nivel > NMax)
        Error(1);
    else
        escopo[nivel] = L;
    printf("\nEntrada no nivel  %d",nivel);
}

void Out_Block() {
    int S, B, k;
    char ident[10];
    S = L;
    B = escopo[nivel];
    while (S > B) {
        S--;
        strcpy(ident,TabelaS[S].nome);
        k = ident[1];
        TabHash[k] = TabelaS[S].col;
    }
    printf("\nSaida do nivel %d",nivel);
    nivel--;
    L = B;
}

int Get_Entry(char x[10]) {
    int n, aux, achou, k;
    achou = 0;
    n = x[0];
    k = TabHash[n];
    while (k != 0 && achou == 0) {
        aux = strcmp(TabelaS[k].nome, x);
        if (aux == 0)
            achou = 1;
        else
            k = TabelaS[k].col;
    }

    if (achou == 1) {
        printf("O item esta no nivel  %d", TabelaS[k].nivel);
        printf("               Indice %u",k);

        return k; /* Retorna o indice no vetor TabelaS do elemento procurado*/
    } else {
        Error(2);
        return(0);
    }
}

void Insert(char X[10], char atribut[10], Tipo tipo) {
    int n, igual, k, aux;
    igual = 0;
    n = Hashing(X); /* Calcula o hashing(X)*/
    k = TabHash[n];

    while (k >= escopo[nivel]) {
        aux = strcmp(TabelaS[k].nome, X);
        if (aux == 0) {
            Error(3);
            igual = 1;
        }
        k = TabelaS[k].col;
    }

    if (L == NMax + 1)
        Error(1);
    else if (igual == 0) {
        TabelaS[L].nivel = nivel;
        aux = strlen(atribut);
        for (k = 0; k<= aux-1; k++)
            TabelaS[L].atributo[k] = atribut[k];
        aux = strlen(X);
        for (k = 0; k<=(aux-1); k++)
            TabelaS[L].nome[k] = X[k];
        TabelaS[L].col = TabHash[n];
        TabHash[n] = L;
        L++;
    }
}

void Print_Table() {
    for (int i = 1; i <= L-1; i++) {
        printf("\n\nNome: ");
        printf("%s", TabelaS[i].nome);
        printf("\n");
        printf("Atributo : ");
        printf("%s", TabelaS[i].atributo);
        printf("\n");
        printf("Nivel : ");
        printf("%i", TabelaS[i].nivel);
        printf("\n");
        printf("\n");
    }
}
