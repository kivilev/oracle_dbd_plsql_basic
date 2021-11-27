package ru.oralcedbd.openapikiviwallet.utils;

import com.google.common.collect.ImmutableBiMap;
import org.apache.commons.lang3.EnumUtils;

import java.util.function.Function;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public class EnumIdValueMap<I, E extends Enum<E>> {

    private final ImmutableBiMap<I, E> map;

    public EnumIdValueMap(Class<E> enumClass, Function<E, I> idMapper) {
        ImmutableBiMap.Builder<I, E> builder = new ImmutableBiMap.Builder<>();

        for (E v : EnumUtils.getEnumList(enumClass)) {
            builder.put(idMapper.apply(v), v);
        }

        map = builder.build();
    }

    public I toId(E v) {
        return getWithKeyCheck(map.inverse(), v);
    }

    public E toValue(I id) {
        return getWithKeyCheck(map, id);
    }

    private static <K, V> V getWithKeyCheck(ImmutableBiMap<K, V> map, K key) {
        checkNotNull(key, "Key is null");
        checkArgument(map.containsKey(key), key + " is not in map");
        return map.get(key);
    }
}
