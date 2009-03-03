# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$pkgver = "1.1.0"
$configurations = "release", "debug"
$frameworks = "mono-2.0", "net-1.1", "net-2.0", "net-3.5", "netcf-2.0"

function package-legalfiles($zipfile)
{
	zip -9 -u -j "$zipfile" ..\LICENSE.txt
	zip -9 -u -j "$zipfile" ..\NOTICE.txt
}

if(!(test-path package))
{
	md package
}

pushd build

# Application files
foreach($configuration in $configurations)
{
	$zipfile = "..\package\Apache.NMS-$pkgver-$configuration.zip"
	package-legalfiles $zipfile
	foreach($framework in $frameworks)
	{
		zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.dll"
	}
}

# PDB Files
foreach($configuration in $configurations)
{
	$zipfile = "..\package\Apache.NMS-$pkgver-$configuration-PDBs.zip"
	package-legalfiles $zipfile
	foreach($framework in $frameworks)
	{
		if($framework -ieq "mono-2.0")
		{
			zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.dll.mdb"
		}
		else
		{
			zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.pdb"
		}
	}
}

# Unit test files
foreach($configuration in $configurations)
{
	$zipfile = "..\package\Apache.NMS-$pkgver-$configuration-UnitTests.zip"
	package-legalfiles $zipfile
	foreach($framework in $frameworks)
	{
		zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.Test.dll"
		if($framework -ieq "mono-2.0")
		{
			zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.Test.dll.mdb"
		}
		else
		{
			zip -9 -u "$zipfile" "$framework\$configuration\Apache.NMS.Test.pdb"
		}
	}
}

popd