import SwiftUI

private typealias CSS = CSSStyleUtil

@available(iOS 15.0, macOS 10.15, *)
struct RenderBlock: View {
    var block: BuilderBlock
    var body: some View {
        let finalStyles = CSS.getFinalStyle(responsiveStyles: block.responsiveStyles );
        let hasBgColor = finalStyles["backgroundColor"] != nil;

        let hasMinHeight = finalStyles["minHeight"] != nil;
        let minHeight = CSS.getFloatValue(cssString: finalStyles["minHeight"] ?? "0px");
        let bgColor = CSS.getColor(value: finalStyles["backgroundColor"]);
        let textAlignValue = finalStyles["textAlign"]
        let horizontalAlignment = CSS.getHorizontalAlignmentFromMargin(styles: finalStyles)
        let cornerRadius = CSS.getFloatValue(cssString:finalStyles["borderRadius"] ?? "0px")
        let borderWidth = CSS.getFloatValue(cssString:finalStyles["borderWidth"] ?? "0px")
        let borderColor = CSS.getColor(value: finalStyles["borderColor"] ?? "none");
        let alignment = horizontalAlignment == HorizontalAlignment.LeftAlign ? Alignment.leading : (horizontalAlignment == HorizontalAlignment.Center ? Alignment.center : Alignment.trailing)
        let name = block.component?.name
        let isEmptyView = (name == nil || componentDict[name!]  == nil) && block.children == nil;
        if  finalStyles["display"] != "none" {
            if (isEmptyView) {
                Rectangle()
                    .if(hasMinHeight) { view in
                        view.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 10, idealHeight: 10, alignment: alignment)
                    }
                    .if(!hasMinHeight) { view in
                        view.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: alignment)
                    }
                    .if(hasBgColor) { view in
                        view.foregroundColor(bgColor)
                    }
                    
            } else {
                VStack(alignment: .center, spacing: 0) {
                    
                    if name != nil {
                        let factoryValue = componentDict[name!]
                        
                        if factoryValue != nil && block.component?.options! != nil {
                            AnyView(_fromValue: factoryValue!(block.component!.options!, finalStyles, block.children))
                        }
                    }
                    
                    if name == nil || !(componentDict[name!] != nil && block.component?.options! != nil) {
    //                    let _ = print("No Name for component or no factory", name ?? "NO NAME")
                        if block.children != nil {
                            RenderBlocks(blocks: block.children!)
                        }
                    }
                }

                .padding(CSS.getBoxStyle(boxStyleProperty: "padding", finalStyles: finalStyles))
    //            .if(hasBgColor) { view in
    //                view.background(bgColor)
    //            }
                .background(Color.purple)
                .padding(CSS.getBoxStyle(boxStyleProperty: "margin", finalStyles: finalStyles))
                .multilineTextAlignment(textAlignValue == "center" ? .center : textAlignValue == "right" ? .trailing : .leading)
                .if(hasMinHeight) { view in
                    view.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 10, idealHeight: 10, alignment: alignment)
                }
                .if(!hasMinHeight) { view in
                    view.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: alignment)
                }
                
                .cornerRadius(cornerRadius)
            }
            
          
        }

        

    }
    
}
