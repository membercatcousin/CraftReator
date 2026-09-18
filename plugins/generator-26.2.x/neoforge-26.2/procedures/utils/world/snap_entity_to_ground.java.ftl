private static void snapEntityToGround(LevelAccessor world, Entity entity, ClipContext.Fluid fluidMode) {
    Vec3 from = entity.position();
    if (from.y <= world.getMinY())
        return;
    BlockHitResult hit = world.clip(new ClipContext(from, new Vec3(from.x, world.getMinY(), from.z),
            ClipContext.Block.COLLIDER, fluidMode, CollisionContext.of(entity)));
    if (hit.getType() == HitResult.Type.MISS)
        return;
    Vec3 to = hit.getLocation();
    entity.teleportTo(to.x, to.y, to.z);
    if (entity instanceof ServerPlayer serverPlayer)
        serverPlayer.connection.teleport(to.x, to.y, to.z, entity.getYRot(), entity.getXRot());
}