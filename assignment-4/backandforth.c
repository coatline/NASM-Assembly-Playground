#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern int addstr(char *a, char *b);
extern int is_palindromeASM(char *s);
extern int factstr(char *s);
extern void palindrome_check();

// Called from Assembly
int fact(int n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
}

// Called from Assembly
int is_palindromeC(char *s) {
    int len = 0;
    
    while (s[len] != '\0')
        len++;
    
    for (int i = 0; i < len / 2; i++) {
        if (s[i] != s[len - 1 - i])
            return 0;
    }
    
    return 1;
}

int main() {
    int choice;
    char s1[100];
    char s2[100];

    while (true) {
        printf("\n1) Add two numbers together\n2) Test if a string is a palindrome (C -> ASM)\n3) Print the factorial of a number\n4) Test if a string is a palindrome (ASM -> C)\n5) Exit\nEnter choice: ");
        scanf("%d", &choice);
        getchar(); // clear newline

        if (choice == 1) {
            printf("Enter first num: ");
            scanf("%s", s1);
            printf("Enter second num: ");
            scanf("%s", s2);
            printf("Sum = %d\n", addstr(s1, s2));
        } else if (choice == 2) {
            printf("Enter a string: ");
            scanf("%s", s1);
            if (is_palindromeASM(s1))
                printf("It is a palindrome!\n");
            else
                printf("Not a palindrome.\n");
        } else if (choice == 3) {
            printf("Enter num: ");
            scanf("%s", s1);
            printf("Factorial: %d\n", factstr(s1));
        } else if (choice == 4) {
            palindrome_check();
        } else {
            break;
        }
    }

    return 0;
}