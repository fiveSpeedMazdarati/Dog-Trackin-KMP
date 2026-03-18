package com.softwareofnote.dogtrackin

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform