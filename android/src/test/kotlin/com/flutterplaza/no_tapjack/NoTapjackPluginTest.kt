package com.flutterplaza.no_tapjack

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class NoTapjackPluginTest {
    @Test
    fun onMethodCall_startListening_returnsSuccess() {
        val plugin = NoTapjackPlugin()

        val call = MethodCall("startListening", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("Listening started")
    }

    @Test
    fun onMethodCall_stopListening_returnsSuccess() {
        val plugin = NoTapjackPlugin()

        val call = MethodCall("stopListening", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("Listening stopped")
    }

    @Test
    fun onMethodCall_enableFilterTouches_returnsTrue() {
        val plugin = NoTapjackPlugin()

        val call = MethodCall("enableFilterTouches", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success(true)
    }

    @Test
    fun onMethodCall_disableFilterTouches_returnsTrue() {
        val plugin = NoTapjackPlugin()

        val call = MethodCall("disableFilterTouches", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success(true)
    }

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = NoTapjackPlugin()

        val call = MethodCall("unknownMethod", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
