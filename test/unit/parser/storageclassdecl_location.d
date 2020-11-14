module parser.storageclassdecl_location;

import dmd.frontend : parseModule;
import support : afterEach, beforeEach;
import dmd.attrib : StorageClassDeclaration;
import dmd.globals : Loc;
import dmd.visitor : SemanticTimeTransitiveVisitor;

@beforeEach
void initializeFrontend()
{
    import dmd.frontend : initDMD;

    initDMD();
}

@afterEach
void deinitializeFrontend()
{
    import dmd.frontend : deinitializeDMD;
    deinitializeDMD();
}

extern (C++) class Visitor : SemanticTimeTransitiveVisitor
{
    alias visit = typeof(super).visit;
    Loc loc;
    override void visit(StorageClassDeclaration scd)
    {
        loc = scd.loc;
    }
}

immutable struct Test
{
    /*
     * The description of the unit test.
     *
     * This will go into the UDA attached to the `unittest` block.
     */
    string description_;

    /*
     * The code to parse.
     *
     */
    string code_;

    string code()
    {
        return code_;
    }

    string description()
    {
        return description_;
    }
}

enum tests = [
    Test("const: decl", "const: int a = 5;"),
    Test("const { decl }", "const { int a = 5; }"),
    Test("const class", "const class C {};"),
    Test("const struct", "const struct S {};"),
    Test("const interface", "const interface I {};"),
    Test("const union", "const union U;"),

    Test("immutable: decl", "immutable: int a = 5;"),
    Test("immutable { decl }", "immutable { int a = 5; }"),
    Test("immutable class", "immutable class C {};"),
    Test("immutable struct", "immutable struct S {};"),
    Test("immutable interface", "immutable interface I {};"),
    Test("immutable union", "immutable union U;"),

    Test("shared: decl", "shared: int a = 5;"),
    Test("shared { decl }", "shared { int a = 5; }"),
    Test("shared class", "shared class C {};"),
    Test("shared struct", "shared struct S {};"),
    Test("shared interface", "shared interface I {};"),
    Test("shared union", "shared union U;"),

    Test("static: decl", "static: int a = 5;"),
    Test("static { decl }", "static { int a = 5; }"),
    Test("static class", "static class C {};"),
    Test("static struct", "static struct S {};"),
    Test("static interface", "static interface I {};"),
    Test("static union", "static union U;"),

    Test("final: decl", "final: int a = 5;"),
    Test("final { decl }", "final { int a = 5; }"),
    Test("final class", "final class C {};"),
    Test("final struct", "final struct S {};"),
    Test("final interface", "final interface I {};"),
    Test("final union", "final union U;"),

    Test("scope: decl", "scope: int a = 5;"),
    Test("scope { decl }", "scope { int a = 5; }"),
    Test("scope class", "scope class C {};"),
    Test("scope struct", "scope struct S {};"),
    Test("scope interface", "scope interface I {};"),
    Test("scope union", "scope union U;"),

    Test("synchronized: decl", "synchronized: int a = 5;"),
    Test("synchronized { decl }", "synchronized { int a = 5; }"),
    Test("synchronized class", "synchronized class C {};"),
    Test("synchronized struct", "synchronized struct S {};"),
    Test("synchronized interface", "synchronized interface I {};"),
    Test("synchronized union", "synchronized union U;"),
];

static foreach (test; tests)
{
    @(test.description)
    unittest
    {
        auto t = parseModule("test.d", "first_token " ~ test.code);

        scope visitor = new Visitor;
        t.module_.accept(visitor);

        assert(visitor.loc.linnum == 1);
        assert(visitor.loc.charnum == 13);
        assert(visitor.loc.fileOffset == 12);
    }
}
