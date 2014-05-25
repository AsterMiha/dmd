// REQUIRED_ARGS: -vgc -o-
// PERMUTE_ARGS:

/***************** CatExp *******************/

/*
TEST_OUTPUT:
---
compilable/vgc2.d(21): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(22): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(23): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(25): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(26): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(27): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(28): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(29): vgc: Concatenation may cause gc allocation
---
*/
void testCat(int[] a, string s)
{
    int[] a1 = a ~ a;
    int[] a2 = a ~ 1;
    int[] a3 = 1 ~ a;

    string s1 = s ~ s;
    string s2 = s ~ "a";
    string s3 = "a" ~ s;
    string s4 = s ~ 'c';
    string s5 = 'c' ~ s;

    string s6 = "a" ~ "b";      // no error
    string s7 = "a" ~ 'c';      // no error
    string s8 = 'c' ~ "b";      // no error
}

/***************** CatAssignExp *******************/

/*
TEST_OUTPUT:
---
compilable/vgc2.d(48): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(50): vgc: Concatenation may cause gc allocation
compilable/vgc2.d(51): vgc: Concatenation may cause gc allocation
---
*/
void testCatAssign(int[] a, string s)
{
    a ~= 1;

    s ~= "a";
    s ~= 'c';
}

/***************** ArrayLiteralExp *******************/

int* barA();

/*
TEST_OUTPUT:
---
compilable/vgc2.d(68): vgc: Array literals cause gc allocation
compilable/vgc2.d(71): vgc: Array literals cause gc allocation
compilable/vgc2.d(72): vgc: Array literals cause gc allocation
---
*/
void testArray()
{
    enum arrLiteral = [null, null]; // should not be error

    int* p;
    auto a = [p, p, barA()];
    a = arrLiteral;
}

/***************** AssocArrayLiteralExp *******************/

/*
TEST_OUTPUT:
---
compilable/vgc2.d(87): vgc: Associative array literals cause gc allocation
compilable/vgc2.d(89): vgc: Associative array literals cause gc allocation
compilable/vgc2.d(90): vgc: Associative array literals cause gc allocation
---
*/
void testAssocArray()
{
    enum aaLiteral = [10: 100]; // should not be error

    auto aa = [1:1, 2:3, 4:5];
    aa = aaLiteral;
}

/***************** IndexExp *******************/

/*
TEST_OUTPUT:
---
compilable/vgc2.d(104): vgc: Indexing an associative array may cause gc allocation
compilable/vgc2.d(105): vgc: Indexing an associative array may cause gc allocation
---
*/
void testIndex(int[int] aa)
{
    aa[1] = 0;
    int n = aa[1];
}
