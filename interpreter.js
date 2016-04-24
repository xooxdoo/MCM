(function () {
"use strict";

// NOT DONE YET

class Interpreter {
  constructor(compiler) {
    this.compiler = compiler;
    this.scope = new AssemblyScope();
    this.codgen = new CommandGenerator();
  }
  Enter() {
    this.scope.Push();
  }
  Run(instrs) {
    for (let instr of instrs) {
      this.RunInstruction(instr.type, instr.args);
    }
  }
  RunInstruction(type, args) {
    switch (type) {
      case "IMPORT": {
        let dep = this.scope.Lookup(args.qualifiedName);
        if (dep != null) {
          return dep;
        } else {
          this.scope.Push(args.qualifiedName);
          dep = this.compiler.compileDependancy(args.qualifiedName);
          this.scope.Set(dep).Pop();
          return dep;
        }
      }
      case "NAMESPACE": {
        retrun this.scope.Space(args.namespace);
      }
      case "": {}
    }
  }
}

}())
