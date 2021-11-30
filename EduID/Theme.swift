/*
 * Copyright (c) 2010-2011 SURFnet bv
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of SURFnet bv nor the names of its contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import TiqrCore

final class Theme: TiqrThemeType {
    let primaryColor: UIColor = UIColor(named: "PrimaryColor")!

    let headerFont: UIFont = UIFont(name: "Nunito-Bold", size: 16)!
    let bodyBoldFont: UIFont = UIFont(name: "Nunito-Bold", size: 16)!
    let bodyFont: UIFont = UIFont(name: "SourceSansPro-Regular", size: 14)!

    let buttonFont: UIFont = UIFont(name: "SourceSansPro-Regular", size: 14)!
    let buttonTintColor: UIColor = .white
    let buttonBackgroundColor: UIColor = UIColor(named: "PrimaryColor")!

    let aboutIcon: UIImage? = UIImage(named: "logo_eduID")
    let topBarIcon: UIImage? = UIImage(named: "logo_eduID")
    let bottomBarIcon: UIImage? = UIImage(named: "powered_by_surf")
}
