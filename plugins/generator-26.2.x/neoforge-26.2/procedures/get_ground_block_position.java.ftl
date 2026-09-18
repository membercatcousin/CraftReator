<@addTemplate file="utils/world/ground_block_position.java.ftl"/>
(groundBlockPosition(world, new Vec3(${input$x}, ${input$y}, ${input$z}), ClipContext.Fluid.${field$fluid_mode!"NONE"}))