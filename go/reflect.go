package superhumandocs

import (
	"fmt"
	"net/url"
	"reflect"
	"strconv"
)

func addQueryReflect(values url.Values, name string, value any) {
	rv := reflect.ValueOf(value)
	if !rv.IsValid() {
		return
	}
	if rv.Kind() == reflect.Pointer {
		if rv.IsNil() {
			return
		}
		rv = rv.Elem()
	}
	if rv.Kind() == reflect.Slice || rv.Kind() == reflect.Array {
		for i := 0; i < rv.Len(); i++ {
			addQueryValue(values, name, rv.Index(i).Interface())
		}
		return
	}
	switch rv.Kind() {
	case reflect.String:
		values.Add(name, rv.String())
	case reflect.Bool:
		values.Add(name, strconv.FormatBool(rv.Bool()))
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		values.Add(name, strconv.FormatInt(rv.Int(), 10))
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
		values.Add(name, strconv.FormatUint(rv.Uint(), 10))
	case reflect.Float32, reflect.Float64:
		values.Add(name, strconv.FormatFloat(rv.Float(), 'f', -1, 64))
	default:
		values.Add(name, fmt.Sprint(value))
	}
}
