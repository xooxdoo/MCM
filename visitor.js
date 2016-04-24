(function () {
"use strict";

class Visitor {
  static Visit(node) { 
    switch (node.type) {
      case 'Root':        return this.VisitRoot(node);
      case 'Namespace':   return this.VisitNamespace(node);
      case 'Import':      return this.VisitImport(node);
      case 'Expression':  return this.VisitExpression(node);
    }
  }
}

MCM.Visitor = Visitor;

})();
