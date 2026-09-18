private static Vec3 groundBlockPosition(LevelAccessor world, Vec3 from, ClipContext.Fluid fluidMode) {
    Vec3 floored = new Vec3(Math.floor(from.x), Math.floor(from.y), Math.floor(from.z));
    if (from.y <= world.getMinY())
        return floored;
    BlockHitResult hit = world.clip(new ClipContext(from, new Vec3(from.x, world.getMinY(), from.z),
            ClipContext.Block.COLLIDER, fluidMode, CollisionContext.empty()));
    return hit.getType() == HitResult.Type.MISS ? floored : Vec3.atLowerCornerOf(hit.getBlockPos());
}