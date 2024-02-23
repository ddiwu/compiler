#include "cminusf_builder.hpp"

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())

#define GEN_LABEL() sprintf(labelName, "%08x", context.label++)

// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

char labelName[32];

/*
 * use CMinusfBuilder::Scope to construct scopes
 * scope.enter: enter a new scope
 * scope.exit: exit current scope
 * scope.push: add a new binding to current scope
 * scope.find: find and return the value bound to the name
 */

Value* CminusfBuilder::visit(ASTProgram &node) {
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations) {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}

Value* CminusfBuilder::visit(ASTNum &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.type == TYPE_INT) {
        context.value = CONST_INT(node.i_val);
    } else if (node.type == TYPE_FLOAT) {
        context.value = CONST_FP(node.f_val);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVarDeclaration &node) {
    // TODO: This function is empty now.
    // Add some code here.
    Type *varType;
    //判断是否为数组
    if (node.num == nullptr) {
        if (node.type == TYPE_INT) {
            varType = INT32_T;
        } else {
            varType = FLOAT_T;
        }
    } else {
        if (node.type == TYPE_INT) {
            varType = ArrayType::get(INT32_T, node.num->i_val);
        } else {
            varType = ArrayType::get(FLOAT_T, node.num->i_val);
        }
    }

    Value *newVar;
    if (scope.in_global()) { // Is global variable
        newVar = GlobalVariable::create(node.id, module.get(), varType, false, ConstantZero::get(varType, module.get()));
    } else {
        newVar = builder->create_alloca(varType);
    }
    scope.push(node.id, newVar);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTFunDeclaration &node) {
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;

    std::vector<Type *> paramTypes;

    for (auto &param : node.params) {
        // TODO: Please accomplish param_types.
        //传参
        if (param->isarray) {
            if (param->type == TYPE_INT)
                paramTypes.push_back(INT32PTR_T);
            else
                paramTypes.push_back(FLOATPTR_T);
        } else {
            if (param->type == TYPE_INT)
                paramTypes.push_back(INT32_T);
            else
                paramTypes.push_back(FLOAT_T);
        }
    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, module.get());
    scope.push(node.id, func);
    context.func = func;
    auto funBB = BasicBlock::create(module.get(), "entry", func);
    builder->set_insert_point(funBB);
    scope.enter();
    std::vector<Value *> args;
    for (auto &arg : func->get_args()) {
        args.push_back(&arg);
    }
    for (long unsigned int i = 0; i < node.params.size(); ++i) {
        // TODO: You need to deal with params and store them in the scope.
        Type *argType;
        // int flag = (node.params[i]->isarray << 1) + (node.params[i]->type == TYPE_INT);
        // switch (flag) {
        //     case 0b00:
        //         argType = FLOAT_T; break;
        //     case 0b01:
        //         argType = INT32_T; break;
        //     case 0b10:
        //         argType = FLOATPTR_T; break;
        //     case 0b11:
        //         argType = INT32PTR_T; break;
        //     default: break;
        // }
        auto argAlloca = builder->create_alloca(argType);
        builder->create_store(args[i], argAlloca);
        scope.push(node.params[i]->id, argAlloca);
    }
    node.compound_stmt->accept(*this);
    if (not builder->get_insert_block()->is_terminated())
    {
        if (context.func->get_return_type()->is_void_type())
            builder->create_void_ret();
        else if (context.func->get_return_type()->is_float_type())
            builder->create_ret(CONST_FP(0.));
        else
            builder->create_ret(CONST_INT(0));
    }
    scope.exit();
    return nullptr;
}

Value* CminusfBuilder::visit(ASTParam &node) {
    // TODO: This function is empty now.
    // Add some code here.
    return nullptr;
}

Value* CminusfBuilder::visit(ASTCompoundStmt &node) {
    // TODO: This function is not complete.
    // You may need to add some code here
    // to deal with complex statements.
    scope.enter();
    //本地变量需要新的作用域
    for (auto &decl : node.local_declarations) {
        decl->accept(*this);
    }

    for (auto &stmt : node.statement_list) {
        stmt->accept(*this);
        if (builder->get_insert_block()->is_terminated())
            break;
    }
    scope.exit();
    return nullptr;
}

Value* CminusfBuilder::visit(ASTExpressionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.expression != nullptr) {
        node.expression->accept(*this);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSelectionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    // Create basic blocks
    GEN_LABEL();
    auto trueBB = BasicBlock::create(module.get(), labelName, context.func);
    GEN_LABEL();
    auto falseBB = BasicBlock::create(module.get(), labelName, context.func);
    GEN_LABEL();
    auto endBB = BasicBlock::create(module.get(), labelName, context.func);
    node.expression->accept(*this);

    // Create comparison to zero
    if (context.value->get_type()->is_integer_type()) {
        context.value = builder->create_icmp_ne(context.value, CONST_INT(0));
    } else {
        context.value = builder->create_fcmp_ne(context.value, CONST_FP(0.));
    }
    builder->create_cond_br(context.value, trueBB, falseBB);

    // True branch
    builder->set_insert_point(trueBB);
    scope.enter();
    node.if_statement->accept(*this);
    scope.exit();
    if (!builder->get_insert_block()->is_terminated()) {
        builder->create_br(endBB);
    }

    // False branch
    builder->set_insert_point(falseBB);
    if (node.else_statement != nullptr) {
        scope.enter();
        node.else_statement->accept(*this);
        scope.exit();
        if (!builder->get_insert_block()->is_terminated()) {
            builder->create_br(endBB);
        }
    } else {
        builder->create_br(endBB);
    }

    builder->set_insert_point(endBB);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTIterationStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    GEN_LABEL(); // Condition
    auto condBB = BasicBlock::create(module.get(), labelName, context.func);
    GEN_LABEL(); // Iteration body
    auto bodyBB = BasicBlock::create(module.get(), labelName, context.func);
    GEN_LABEL(); // End
    auto endBB = BasicBlock::create(module.get(), labelName, context.func);

    if (!builder->get_insert_block()->is_terminated()) {
        builder->create_br(condBB);
    }
    builder->set_insert_point(condBB);
    node.expression->accept(*this);
    if (context.value->get_type()->is_integer_type()) {
        context.value = builder->create_icmp_ne(context.value, CONST_INT(0));
    } else {
        context.value = builder->create_fcmp_ne(context.value, CONST_FP(0.));
    }

    builder->create_cond_br(context.value, bodyBB, endBB);
    builder->set_insert_point(bodyBB);
    scope.enter();
    node.statement->accept(*this);
    scope.exit();
    if (!builder->get_insert_block()->is_terminated()) {
        builder->create_br(condBB);
    }
    builder->set_insert_point(endBB);

    return nullptr;
}

Value* CminusfBuilder::visit(ASTReturnStmt &node) {
    if (node.expression == nullptr) {
        builder->create_void_ret();
        return nullptr;
    } else {
        // TODO: The given code is incomplete.
        // You need to solve other return cases (e.g. return an integer).
        node.expression->accept(*this);
        auto retType = context.func->get_function_type()->get_return_type();

        if (retType != context.value->get_type()) { // Data type conversion
            if (context.value->get_type()->is_integer_type()) {
                context.value = builder->create_sitofp(context.value, FLOAT_T);
            } else {
                context.value = builder->create_fptosi(context.value, INT32_T);
            }
        }
        builder->create_ret(context.value);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVar &node) {
    // TODO: This function is empty now.
    // Add some code here.
    context.value = scope.find(node.id);
    if (node.expression == nullptr) {
        if (context.lvalue == 0) {
            if (context.value->get_type()->get_pointer_element_type()->is_array_type()) {
                context.value = builder->create_gep(context.value, {CONST_INT(0), CONST_INT(0)});
            } else {
                context.value = builder->create_load(context.value);
            }
        }
    } else {
        auto *lVal = context.value;
        bool backup = context.lvalue;
        context.lvalue = false;
        node.expression->accept(*this);
        context.lvalue = backup;
        auto *rVal = context.value;
        if (rVal->get_type()->is_float_type()) {
            rVal = builder->create_fptosi(rVal, INT32_T);
        }
        GEN_LABEL();
        auto trueBB = BasicBlock::create(module.get(), labelName, context.func);
        GEN_LABEL();
        auto falseBB = BasicBlock::create(module.get(), labelName, context.func);
        GEN_LABEL();
        auto endBB = BasicBlock::create(module.get(), labelName, context.func);
        auto *cond = builder->create_icmp_ge(rVal, CONST_INT(0));
        builder->create_cond_br(cond, trueBB, falseBB);
        // True
        builder->set_insert_point(trueBB);
        if (lVal->get_type()->get_pointer_element_type()->is_integer_type() || lVal->get_type()->get_pointer_element_type()->is_float_type()) {
            context.value = builder->create_gep(lVal, {rVal});
        } else if (lVal->get_type()->get_pointer_element_type()->is_pointer_type()) {
            lVal = builder->create_load(lVal);
            context.value = builder->create_gep(lVal, {rVal});
        } else {
            context.value = builder->create_gep(lVal, {CONST_INT(0), rVal});
        }
        if (context.lvalue == 0) {
            context.value = builder->create_load(context.value);
        }
        builder->create_br(endBB);
        // False
        builder->set_insert_point(falseBB);
        builder->create_call(scope.find("neg_idx_except"), {});
        builder->create_br(endBB);
        // End
        builder->set_insert_point(endBB);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    context.lvalue = true;
    node.var->accept(*this);
    context.lvalue = false;

    auto orig = context.value;
    node.expression->accept(*this);
    auto varAlloca = context.value;
    auto varType = varAlloca->get_type();

    if (orig->get_type()->get_pointer_element_type() != varType) {
        if (varType->is_integer_type()) {
            varAlloca = builder->create_sitofp(varAlloca, FLOAT_T);
        } else {
            varAlloca = builder->create_fptosi(varAlloca, INT32_T);
        }
    }
    builder->create_store(varAlloca, orig);
    context.value = varAlloca;
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    node.additive_expression_l->accept(*this);
    if (node.additive_expression_r == nullptr) { // Only left expression
        return nullptr;
    }
    auto *lVal = context.value;
    node.additive_expression_r->accept(*this);
    auto *rVal = context.value;
    // Data type conversion
    if (lVal->get_type()->is_float_type() || context.value->get_type()->is_float_type()) { // Has float
        if (lVal->get_type()->is_integer_type()) {
            lVal = builder->create_sitofp(lVal, FLOAT_T);
        }
        if (rVal->get_type()->is_integer_type()) {
            rVal = builder->create_sitofp(rVal, FLOAT_T);
        }
        switch (node.op) {
            case OP_LT:
                context.value = builder->create_fcmp_lt(lVal, rVal); break;
            case OP_GT:
                context.value = builder->create_fcmp_gt(lVal, rVal); break;
            case OP_LE:
                context.value = builder->create_fcmp_le(lVal, rVal); break;
            case OP_GE:
                context.value = builder->create_fcmp_ge(lVal, rVal); break;
            case OP_EQ:
                context.value = builder->create_fcmp_eq(lVal, rVal); break;
            case OP_NEQ:
                context.value = builder->create_fcmp_ne(lVal, rVal); break;
        }
    } else {
        switch (node.op) {
            case OP_LT:
                context.value = builder->create_icmp_lt(lVal, rVal); break;
            case OP_GT:
                context.value = builder->create_icmp_gt(lVal, rVal); break;
            case OP_LE:
                context.value = builder->create_icmp_le(lVal, rVal); break;
            case OP_GE:
                context.value = builder->create_icmp_ge(lVal, rVal); break;
            case OP_EQ:
                context.value = builder->create_icmp_eq(lVal, rVal); break;
            case OP_NEQ:
                context.value = builder->create_icmp_ne(lVal, rVal); break;
        }
    }
    context.value = builder->create_zext(context.value, INT32_T);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.additive_expression == nullptr) {
        node.term->accept(*this);
    } else {
        node.additive_expression->accept(*this);
        auto *lVal = context.value;
        node.term->accept(*this);
        auto *rVal = context.value;

        if (lVal->get_type()->is_float_type() || context.value->get_type()->is_float_type()) { // Has float
            if (lVal->get_type()->is_integer_type()) {
                lVal = builder->create_sitofp(lVal, FLOAT_T);
            }
            if (rVal->get_type()->is_integer_type()) {
                rVal = builder->create_sitofp(rVal, FLOAT_T);
            }
            if (node.op == OP_PLUS) {
                context.value = builder->create_fadd(lVal, rVal);
            } else if (node.op == OP_MINUS) {
                context.value = builder->create_fsub(lVal, rVal);
            }
        } else {
            if (node.op == OP_PLUS) {
                context.value = builder->create_iadd(lVal, rVal);
            } else if (node.op == OP_MINUS) {
                context.value = builder->create_isub(lVal, rVal);
            }
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.term == nullptr) {
        node.factor->accept(*this);
        return nullptr;
    }
    node.term->accept(*this);
    auto *lVal = context.value;
    node.factor->accept(*this);
    auto *rVal = context.value;

    if (lVal->get_type()->is_float_type() || context.value->get_type()->is_float_type()) { // Has float
        if (lVal->get_type()->is_integer_type()) {
            lVal = builder->create_sitofp(lVal, FLOAT_T);
        }
        if (rVal->get_type()->is_integer_type()) {
            rVal = builder->create_sitofp(rVal, FLOAT_T);
        }
        if (node.op == OP_MUL) {
            context.value = builder->create_fmul(lVal, rVal);
        } else if (node.op == OP_DIV) {
            context.value = builder->create_fdiv(lVal, rVal);
        }
    } else {
        if (node.op == OP_MUL) {
            context.value = builder->create_imul(lVal, rVal);
        } else if (node.op == OP_DIV) {
            context.value = builder->create_isdiv(lVal, rVal);
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTCall &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto *func = (Function *)(scope.find(node.id));
    auto param = func->get_function_type()->param_begin();
    std::vector<Value *> args;
    for (auto &arg : node.args) {
        arg->accept(*this);
        auto *vType = context.value->get_type();
        if (vType != *param && !vType->is_pointer_type()) {
            if (vType->is_integer_type()) {
                context.value = builder->create_sitofp(context.value, *param);
            } else {
                context.value = builder->create_fptosi(context.value, *param);
            }
        }
        param++;
        args.push_back(context.value);
    }
    context.value = builder->create_call(func, args);
    return nullptr;
}
