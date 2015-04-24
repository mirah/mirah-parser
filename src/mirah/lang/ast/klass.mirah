package mirahparser.lang.ast
import java.util.Collections
import java.util.List

# Note: com.sun.source.tree uses the same node for classes, interfaces, annotations, etc.
class ClassDefinition < NodeImpl
  implements Annotated, Named, HasModifiers
  init_node do
    child name: Identifier
    child superclass: TypeName
    child_list body: Node
    child_list interfaces: TypeName
    child_list annotations: Annotation
    child_list modifiers: Modifier
  end

end

class InterfaceDeclaration < ClassDefinition
  init_subclass(ClassDefinition)
end

# Is this necessary?
class ClosureDefinition < ClassDefinition
  init_subclass(ClassDefinition)
end

class FieldDeclaration < NodeImpl
  implements Annotated, Named, HasModifiers
  init_node do
    child name: Identifier
    child type: TypeName
    child_list annotations: Annotation
    attr_accessor isStatic: 'boolean'
    child_list modifiers: Modifier
  end
end

class FieldAssign < NodeImpl
  implements Annotated, Named, Assignment, HasModifiers
  init_node do
    child name: Identifier
    child value: Node
    child_list annotations: Annotation
    attr_accessor isStatic: 'boolean'
    child_list modifiers: Modifier
  end

  def initialize(position:Position, name:Identifier, annotations:List, isStatic:boolean, modifiers: List)
    initialize(position, name, Node(nil), annotations, modifiers)
    self.isStatic = isStatic
  end

  def initialize(position:Position, name:Identifier, annotations:List, isStatic:boolean)
    initialize(position, name, Node(nil), annotations, nil)
    self.isStatic = isStatic
  end


end

class FieldAccess < NodeImpl
  implements Named
  init_node do
    child name: Identifier
    attr_accessor isStatic: 'boolean'
  end

  def initialize(position:Position, name:Identifier, isStatic:boolean)
    initialize(position, name)
    self.isStatic = isStatic
  end
end

class Include < NodeImpl
  init_node do
    child_list includes: TypeName
  end
end

class Constant < NodeImpl
  implements Named, TypeName, Identifier
  init_node do
    child name: Identifier
    attr_accessor isArray: 'boolean'  # TODO This doesn't seem right
  end

  def identifier:String
    name.identifier
  end
  def typeref:TypeRef
    TypeRefImpl.new(name.identifier, @isArray, false, position)
  end
end

class Colon3 < Constant
  init_subclass(Constant)
  def typeref:TypeRef
    TypeRefImpl.new("::#{identifier}", false, false, position)
  end
end

class ConstantAssign < NodeImpl
  implements Annotated, Named, Assignment, HasModifiers
  init_node do
    child name: Identifier
    child value: Node
    child_list annotations: Annotation
    child_list modifiers: Modifier
  end
end

class AttrAssign < NodeImpl
  implements Named, Assignment
  init_node do
    child target: Node
    child name: Identifier
    child value: Node
  end
end

class ElemAssign < NodeImpl
  implements Assignment
  init_node do
    child target: Node
    child_list args: Node
    child value: Node
  end
end