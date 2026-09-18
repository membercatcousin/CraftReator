<@addTemplate file="utils/world/ground_position.java.ftl"/>
(groundPosition(world, new Vec3(${input$x}, ${input$y}, ${input$z}), ClipContext.Fluid.${field$fluid_mode!"NONE"}))