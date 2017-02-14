//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let storyboardsCommand = command(
  outputOption,
  templateOption(prefix: "storyboards"), templatePathOption,
  Option<String>("sceneEnumName", "StoryboardScene", flag: "e",
    description: "The name of the enum to generate for Scenes"),
  Option<String>("segueEnumName", "StoryboardSegue", flag: "g",
    description: "The name of the enum to generate for Segues"),
  // Note: import option is deprecated.
  VariadicOption<String>("import", [],
    description: "Additional imports to be added to the generated file (DEPRECATED)"),
  VariadicArgument<Path>("PATH",
    description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
    validator: pathsExist)
) { output, templateName, templatePath, sceneEnumName, segueEnumName, _, paths in
  let parser = StoryboardParser()

  do {
    for path in paths {
      if path.extension == "storyboard" {
        try parser.addStoryboard(at: path)
      } else {
        try parser.parseDirectory(at: path)
      }
    }

    let templateRealPath = try findTemplate(
      prefix: "storyboards",
      templateShortName: templateName,
      templateFullPath: templatePath
    )
    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())
    let context = parser.stencilContext(
      sceneEnumName: sceneEnumName, segueEnumName: segueEnumName
    )
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: \(error.localizedDescription)")
  }
}
