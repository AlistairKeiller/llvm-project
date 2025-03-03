//===-- OpenMPOpsInterfaces.td - OpenMP op interfaces ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is the OpenMP Dialect interfaces definition file.
//
//===----------------------------------------------------------------------===//

#ifndef OpenMP_OPS_INTERFACES
#define OpenMP_OPS_INTERFACES

include "mlir/IR/OpBase.td"

def OutlineableOpenMPOpInterface : OpInterface<"OutlineableOpenMPOpInterface"> {
  let description = [{
    OpenMP operations whose region will be outlined will implement this
    interface. These operations will
  }];

  let cppNamespace = "::mlir::omp";

  let methods = [
    InterfaceMethod<"Get alloca block", "::mlir::Block*", "getAllocaBlock",
      (ins), [{
      return &$_op.getRegion().front();
      }]>,
  ];
}

def ReductionClauseInterface : OpInterface<"ReductionClauseInterface"> {
  let description = [{
    OpenMP operations that support reduction clause have this interface.
  }];

  let cppNamespace = "::mlir::omp";

  let methods = [
    InterfaceMethod<
      "Get reduction vars", "::mlir::SmallVector<::mlir::Value>",
      "getAllReductionVars", (ins), [{}], [{
        return $_op.getReductionVars();
      }]>,
  ];
}

def OffloadModuleInterface : OpInterface<"OffloadModuleInterface"> {
  let description = [{
    Operations that represent a module for offloading (host or device)
    should have this interface.
  }];

  let cppNamespace = "::mlir::omp";

  let methods = [
    InterfaceMethod<
      /*description=*/[{
        Set the attribute IsDeviceAttr on the current module with the
        specified boolean argument.
      }],
      /*retTy=*/"void",
      /*methodName=*/"setIsDevice",
      (ins "bool":$isDevice), [{}], [{
        $_op->setAttr(
          mlir::StringAttr::get($_op->getContext(), llvm::Twine{"omp.is_device"}),
            mlir::omp::IsDeviceAttr::get($_op->getContext(), isDevice));
      }]>,
      InterfaceMethod<
      /*description=*/[{
        Get the IsDeviceAttr attribute on the current module if it exists and return
        its value, if it doesn't exist it returns false by default.
      }],
      /*retTy=*/"bool",
      /*methodName=*/"getIsDevice",
      (ins), [{}], [{
        if (Attribute isDevice = $_op->getAttr("omp.is_device"))
          if (::llvm::isa<mlir::omp::IsDeviceAttr>(isDevice))
            return ::llvm::dyn_cast<IsDeviceAttr>(isDevice).getIsDevice();
        return false;
      }]>,
      InterfaceMethod<
      /*description=*/[{
        Get the FlagsAttr attribute on the current module if it exists
        and return the attribute, if it doesn't exit it returns a nullptr
      }],
      /*retTy=*/"mlir::omp::FlagsAttr",
      /*methodName=*/"getFlags",
      (ins), [{}], [{
        if (Attribute flags = $_op->getAttr("omp.flags"))
          return flags.dyn_cast_or_null<mlir::omp::FlagsAttr>();
        return nullptr;
      }]>,
      InterfaceMethod<
      /*description=*/[{
        Apply an omp.FlagsAttr to a module with the specified values
        for the flags
      }],
      /*retTy=*/"void",
      /*methodName=*/"setFlags",
      (ins "uint32_t":$debugKind,
            "bool":$assumeTeamsOversubscription,
            "bool":$assumeThreadsOversubscription,
            "bool":$assumeNoThreadState,
            "bool":$assumeNoNestedParallelism), [{}], [{
        $_op->setAttr(("omp." + mlir::omp::FlagsAttr::getMnemonic()).str(),
                  mlir::omp::FlagsAttr::get($_op->getContext(), debugKind,
                      assumeTeamsOversubscription, assumeThreadsOversubscription,
                      assumeNoThreadState, assumeNoNestedParallelism));
      }]>,
    InterfaceMethod<
      /*description=*/[{
        Get the Target attribute on the current module if it exists
        and return the attribute, if it doesn't exist it returns a nullptr.
      }],
      /*retTy=*/"mlir::omp::TargetAttr",
      /*methodName=*/"getTarget",
      (ins), [{}], [{
        if (Attribute flags = $_op->getAttr("omp.target"))
          return flags.dyn_cast_or_null<mlir::omp::TargetAttr>();
        return nullptr;
      }]>,
    InterfaceMethod<
      /*description=*/[{
        Set the attribute target on the current module with the
        specified string arguments - name of cpu and corresponding features.
      }],
      /*retTy=*/"void",
      /*methodName=*/"setTarget",
      (ins "llvm::StringRef":$targetCPU,
           "llvm::StringRef":$targetFeatures), [{}], [{
        if (targetCPU.empty())
          return;
        $_op->setAttr(("omp." + mlir::omp::TargetAttr::getMnemonic()).str(),
                  mlir::omp::TargetAttr::get($_op->getContext(),
                                             targetCPU.str(),
                                             targetFeatures.str()));
      }]>,
      InterfaceMethod<
      /*description=*/[{
        Set a StringAttr on the current module containing the host IR file path. This
        file path is used in two-phase compilation during the device phase to generate
        device side LLVM IR when lowering MLIR.
      }],
      /*retTy=*/"void",
      /*methodName=*/"setHostIRFilePath",
      (ins "std::string":$hostIRFilePath), [{}], [{
        $_op->setAttr(
          mlir::StringAttr::get($_op->getContext(), llvm::Twine{"omp.host_ir_filepath"}),
            mlir::StringAttr::get($_op->getContext(), hostIRFilePath));
       }]>,
      InterfaceMethod<
      /*description=*/[{
        Find the host-ir file path StringAttr from the current module if it exists and
        return its contained value, if it doesn't exist it returns an empty string. This
        file path is used in two-phase compilation during the device phase to generate
        device side LLVM IR when lowering MLIR.
      }],
      /*retTy=*/"llvm::StringRef",
      /*methodName=*/"getHostIRFilePath",
      (ins), [{}], [{
        if (Attribute filepath = $_op->getAttr("omp.host_ir_filepath"))
          if (::llvm::isa<mlir::StringAttr>(filepath))
            return ::llvm::dyn_cast<mlir::StringAttr>(filepath).getValue();
        return {};
      }]>
  ];
}

#endif // OpenMP_OPS_INTERFACES
