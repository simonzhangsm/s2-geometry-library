project(s2 CXX)
set(PROJECT_NAME s2)
cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
add_definitions(-DS2_USE_EXACTFLOAT -DHASH_NAMESPACE=std)
set_property(GLOBAL PROPERTY CXX_STANDARD 11)
set_property(GLOBAL PROPERTY CXX_STANDARD_REQUIRED ON)

IF ( NOT OPENSSL_INCLUDE_DIR OR NOT OPENSSL_LIBRARIES )
    find_package(OpenSSL REQUIRED)
ENDIF()

message("OpenSSL include dir: ${OPENSSL_INCLUDE_DIR}")
message("OpenSSL libraries dir: ${OPENSSL_LIBRARIES}")

ADD_DEFINITIONS (-Wno-deprecated-declarations -Wno-conversion -DNDEBUG)

INCLUDE_DIRECTORIES( ${OPENSSL_INCLUDE_DIR} )
INCLUDE_DIRECTORIES( s2 . )

set(s2util_files
	base/int128.cc
	base/logging.cc
	base/stringprintf.cc
	base/strtoint.cc
	strings/ascii_ctype.cc
	strings/split.cc
	strings/stringprintf.cc
	strings/strutil.cc
	util/coding/coder.cc
	util/coding/varint.cc
	util/math/exactfloat/exactfloat.cc
	util/math/mathlimits.cc
	util/math/mathutil.cc
)

set(s2cellid_files
	s1angle.cc
	s2.cc
	s2cellid.cc
	s2latlng.cc
)

set(s2_files
	s1interval.cc
	s2cap.cc
	s2cell.cc
	s2cellunion.cc
	s2edgeindex.cc
	s2edgeutil.cc
	s2latlngrect.cc
	s2loop.cc
	s2pointregion.cc
	s2polygon.cc
	s2polygonbuilder.cc
	s2polyline.cc
	s2r2rect.cc
	s2region.cc
	s2regioncoverer.cc
	s2regionintersection.cc
	s2regionunion.cc
)

file(GLOB BASE_HEADERS base/*.h)
file(GLOB S2_HEADERS s2/*.h)                                                             
file(GLOB STR_HEADERS strings/*.h)    
file(GLOB UTIL_CODE_HEADERS util/coding/*.h) 
file(GLOB UTIL_ENDIAN_HEADERS util/endian/*.h)
file(GLOB UTIL_HASH_HEADERS util/hash/*.h)
file(GLOB UTIL_MATH_EXF_HEADERS util/math/exactfloat/*.h)
file(GLOB UTIL_MATH_HEADERS util/math/*.h)

add_library(s2util STATIC ${s2util_files})
target_link_libraries(s2util ${OPENSSL_LIBRARIES})

#add_library(s2util.dy SHARED ${s2util_files})
#target_link_libraries(s2util.dy ${OPENSSL_LIBRARIES})
#SET_TARGET_PROPERTIES(s2util.dy PROPERTIES OUTPUT_NAME "s2util") 
#SET_TARGET_PROPERTIES(s2util PROPERTIES CLEAN_DIRECT_OUTPUT 1) 
#SET_TARGET_PROPERTIES(s2util.dy PROPERTIES CLEAN_DIRECT_OUTPUT 1)

add_library(s2cellid STATIC ${s2cellid_files})
target_link_libraries(s2cellid s2util ${OPENSSL_LIBRARIES})

#add_library(s2cellid.dy SHARED ${s2cellid_files})
#target_link_libraries(s2cellid.dy s2util.dy ${OPENSSL_LIBRARIES})
#SET_TARGET_PROPERTIES(s2cellid.dy PROPERTIES OUTPUT_NAME "s2cellid") 
#SET_TARGET_PROPERTIES(s2cellid PROPERTIES CLEAN_DIRECT_OUTPUT 1) 
#SET_TARGET_PROPERTIES(s2cellid.dy PROPERTIES CLEAN_DIRECT_OUTPUT 1)

add_library(s2 STATIC ${s2_files})
target_link_libraries(s2 s2cellid s2util pthread ${OPENSSL_LIBRARIES})

#add_library(s2.dy SHARED ${s2_files})
#target_link_libraries(s2.dy s2cellid.dy s2util.dy pthread ${OPENSSL_LIBRARIES})
#SET_TARGET_PROPERTIES(s2.dy PROPERTIES OUTPUT_NAME "s2") 
#SET_TARGET_PROPERTIES(s2 PROPERTIES CLEAN_DIRECT_OUTPUT 1) 
#SET_TARGET_PROPERTIES(s2.dy PROPERTIES CLEAN_DIRECT_OUTPUT 1)

install(TARGETS s2util s2cellid s2 #s2util.dy s2cellid.dy s2.dy
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
)   

install(FILES ${S2_HEADERS} DESTINATION    		include/s2)                     
install(FILES ${BASE_HEADERS} DESTINATION      		include/s2/base)                
install(FILES ${STR_HEADERS} DESTINATION        	include/s2/strings)             
install(FILES ${UTIL_CODE_HEADERS} DESTINATION     	include/s2/util/coding)         
install(FILES ${UTIL_ENDIAN_HEADERS} DESTINATION    	include/s2/util/endian)         
install(FILES ${UTIL_MATH_HEADERS} DESTINATION      	include/s2/util/math)           
install(FILES ${UTIL_MATH_EXF_HEADERS} DESTINATION 	include/s2/util/math/exactfloat)
