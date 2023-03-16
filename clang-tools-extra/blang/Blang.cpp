#include "clang/Frontend/CompilerInvocation.h"

clang::EmitObjAction Obj;

extern "C" int compile()
{
    clang::CompilerInstance Clang;

    // llvm::InitializeAllTargets();
    // llvm::InitializeAllTargetMCs();
    // llvm::InitializeAllAsmPrinters();
    // llvm::InitializeAllAsmParsers();

    // Clang.createDiagnostics();
    // Clang.getDiagnosticOpts().ShowColors = true;

    // Clang.getFrontendOpts().Inputs.emplace_back("main.cpp", clang::Language::CXX);
    // Clang.getFrontendOpts().OutputFile = "main.obj";

    // Clang.getHeaderSearchOpts().AddPath("sysroot/include", clang::frontend::System, false, true);
    // Clang.getHeaderSearchOpts().AddPath("sysroot/include/c++/v1", clang::frontend::System, false, true);
    // Clang.getHeaderSearchOpts().AddPath("llvm-project/llvm/lib/clang/16.0.0/include", clang::frontend::System, false, true);

    // Clang->getPreprocessorOpts().addMacroDef("__wasi__");

    // Clang.getTargetOpts().Triple = "wasm32-wasi";

    return Clang.ExecuteAction(Obj);
}