private static Vec3 groundPosition(LevelAccessor world, Vec3 from, ClipContext.Fluid fluidMode) {
    if (from.y <= world.getMinY())
        return from;
    BlockHitResult hit = world.clip(new ClipContext(from, new Vec3(from.x, world.getMinY(), from.z),
            ClipContext.Block.COLLIDER, fluidMode, CollisionContext.empty()));
    return hit.getType() == HitResult.Type.MISS ? from : hit.getLocation();
}